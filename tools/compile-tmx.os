require "std"
require "../data/ELEMENTS_LIST"

print "= BEGIN ============================"
// print process.argv

function usage(){
	print "Usage:"
	print "${process.argv[1]} filename.tmx"
	terminate()
}

var filename = process.argv[2] // || path.dirname(process.argv[1]).."/testmap.tmx"
print "${filename}"
// if(!Regexp(`/\.tmx$/`).test(filename)){
if(path.extname(filename) != ".tmx"){
	usage()
}

function parseAttributes(str){
	var r, m = {}, Regexp(`/([\w\d_]+)=\"([^\"]*)\"/g`).exec(str)
	for(var i, v in m[1]){
		r[v] = m[2][i]
	}
	return r
}

function fixNumbers(obj){
	for(var name, value in obj){
		var num = toNumber(value)
		if("${num}" == value){
			obj[name] = num
		}
	}
	return obj
}

var contents = File.readContents(filename)
var m = Regexp(`/<map\s+(.+?)>/`).exec(contents)
var tmx = fixNumbers(parseAttributes(m[1]))

var elementCount = 0
// var tilesets = {}
var m = Regexp(`#<tileset\s+([^>]+)>(.*?)</tileset>#sg`).exec(contents)
for(var i, v in m[1]){
	var tileset = parseAttributes(v)
	if(tileset.name != "tiledmap-${elementCount}"){
		throw "mismatch tileset name: ${tileset.name}, required: tiledmap-${elementCount}"
	}
	if(tileset.firstgid != elementCount+1){
		throw "error tileset firstgid: ${tileset.firstgid}, required: ${elementCount+1}, adjust tile size"
	}
	var im = Regexp(`#<image source=".+?" width="(\d+)" height="(\d+)"\s*/>#s`).exec(m[2][i])
	// print im; terminate()
	tileset.imagewidth = im[1]
	tileset.imageheight = im[2]
	fixNumbers(tileset)
	tileset.count = (tileset.imagewidth / tileset.tilewidth) * (tileset.imageheight / tileset.tileheight)
	// print tileset; // terminate()
	// tilesets[tileset.name] = tileset
	elementCount = elementCount + tileset.count
}
// print tmx; terminate()

var isPlayerExist = false
var map, tileLayers, items, entities = {}, {}, [], []
var m = Regexp(`#<layer\s+([^>]+)>(.*?)</layer>#sg`).exec(contents)
for(var i, v in m[1]){
	var layer = fixNumbers(parseAttributes(v))
	
	var dm = Regexp(`#<data encoding="base64" compression="zlib">(.*?)</data>#s`).exec(m[2][i])
	// print dm[1].trim()
	var memdata = base64.decode(dm[1].trim())
	// print "memdata: ${memdata}"
	memdata = zlib.gzuncompress(memdata)
	// print "memdata2: ${memdata}"
	
	var width, height = layer.width, layer.height
	if(!map.width){
		map.width = width
		map.height = height
	}else{
		map.width == width || throw "layer: ${layer.name} width ${width} != map width ${map.width}"
		map.height == height || throw "layer: ${layer.name} height ${height} != map height ${map.height}"
	}
	delete layer.width
	delete layer.height

	var data, offs = Buffer(), 0
	for(var y = 0; y < height; y++){
		for(var x = 0; x < width; x++){
			var type = memdata.sub(offs, 4).unpack("V")
			if(type > 0){
				type = type - 1
				if(type >= elementCount){
					throw "${layer.name} layer contains error tile (${type}) at ${x}x${y}"
				}
				if(type == 0){
					map.floor && throw "${layer.name} layer contains duplicate floor at ${x}x${y}"
					map.floor = y+1
				}
			}
			var elem = ELEMENTS_LIST[type] || throw "${layer.name} layer contains error tile (${type}) at ${x}x${y}, not found in ELEMENTS_LIST"
			switch(layer.name){
			case "front":
			case "back":
				if(type > 0){
					elem.isTile || throw "${layer.name} layer contains error tile (${type}) at ${x}x${y}, should be isTile but found: ${elem}"
				}
				data << "v".pack(type)
				break
				
			case "items":
				if(type > 0){
					elem.isItem || throw "${layer.name} layer contains error tile (${type}) at ${x}x${y}, should be isItem but found: ${elem}"
					items[] = {
						type = type,
						tx = x,
						ty = y - elem.rows + 1,
					}
				}
				break
				
			case "entities":
				if(type > 0){
					elem.isEntity || throw "${layer.name} layer contains error tile (${type}) at ${x}x${y}, should be isEntity but found: ${elem}"
					if(type == ELEM_TYPE_ENT_PLAYER){
						isPlayerExist && throw "${layer.name} layer contains duplicate player at ${x}x${y}"
						isPlayerExist = true
					}
					entities[] = {
						type = type,
						x = x * TILE_SIZE + elem.width / 2,
						y = (y+1) * TILE_SIZE - elem.height / 2,
					}
				}
				break
			}
			offs += 4
		}
	}
	switch(layer.name){
	case "front":
	case "back":
		layer.data = data
		tileLayers[layer.name] = layer
		break
	}
}

var tileLayerNames = ["front", "back"]
for(var _, name in tileLayerNames){
	tileLayers[name] || throw "${name} layer is not found in ${filename}"
}
map.items = items
map.entities = entities
map.floor || throw "floor is not set"
isPlayerExist || throw "player is not set"

// print map; terminate()

var filename = "../data/levels/"..path.basename(filename).lower().replace(".tmx", ".json")
File.writeContents(filename, json.encode(map))

var buf = Buffer()
buf << LEVEL_BIN_DATA_PREFIX
buf << tileLayers.front.data
buf << tileLayers.back.data
// buf << tileLayers.items.data
var data = zlib.gzcompress(buf)
File.writeContents(filename.replace(".json", ".bin"), data)

print "${filename} saved, tile layers: ${#tileLayers}, items: ${#items}, entities: ${#entities}"

var levels = {}
for(var _, filename in fs.readdir("../data/levels")){
	var ext = path.extname(filename)
	if(ext != ".json"){
		if(ext != ".bin"){
			print "found error level file: \"../data/levels/${filename}\""
		}
		continue
	}
	levels[filename.replace(".json", "")] = "levels/${filename}"
}
levels.sort()
var filename = "../data/levels.os"
File.writeContents(filename, <<<END"
/* auto generated file */
return ${json.encode(levels)}
END)

print "${filename} updated, levels: ${#levels}"

print "= END ==============================\n"
