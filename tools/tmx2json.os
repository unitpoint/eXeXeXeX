require "std"

print "= BEGIN ============================"
// print process.argv

function usage(){
	print "Usage:"
	print "${process.argv[1]} filename.tmx"
	terminate()
}

var filename = process.argv[2] || path.dirname(process.argv[1]).."/testmap.tmx"
print "${filename}"
// if(!Regexp(`/\.tmx$/`).test(filename)){
if(path.extname(filename) != ".tmx"){
	usage()
}

function parseAttributes(str){
	var m = Regexp(`/([\w\d_]+)=\"([^\"]*)\"/g`).exec(str)
	var r = {}
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
var map = fixNumbers(parseAttributes(m[1]))

map.tilesets = {}
var m = Regexp(`#<tileset\s+([^>]+)>(.*?)</tileset>#sg`).exec(contents)
for(var i, v in m[1]){
	var tileset = parseAttributes(v)
	var im = Regexp(`#<image source=".+?" width="(\d+)" height="(\d+)"\s*/>#s`).exec(m[2][i])
	// print im; terminate()
	tileset.imagewidth = im[1]
	tileset.imageheight = im[2]
	fixNumbers(tileset)
	tileset.count = (tileset.imagewidth / tileset.tilewidth) * (tileset.imageheight / tileset.tileheight)
	// print tileset; // terminate()
	map.tilesets[tileset.name] = tileset
}

for(var _, name in ["front", "back", "entities", "items"]){
	map.tilesets[name] || throw "${name} tileset is not found in ${filename}"
}

var isPlayerExist = false
var entitiesTileset = map.tilesets.entities
// print "entities tileset: ${map.tilesets.entities}"; terminate()
var parseObject = function(obj){
	obj = fixNumbers(parseAttributes(obj))
	// print obj; // terminate()
	if(obj.gid <= entitiesTileset.firstgid || obj.gid > entitiesTileset.firstgid + entitiesTileset.count){
		if(obj.gid == entitiesTileset.firstgid){
			throw "entities should not use the first tileset gid: ${obj}"
		}
		throw "entities uses error tileset at ${obj}"
	}
	if(obj.type == "player"){
		isPlayerExist && throw "there are more than one player at ${obj}"
		isPlayerExist = true
	}
	obj.gid = obj.gid - map.tilesets.entities.firstgid
	obj.x = math.round(obj.x / map.tilewidth)
	obj.y = math.round(obj.y / map.tileheight - 1)
	// print obj; // terminate()
	return obj
}

var m = Regexp(`#<objectgroup name="([^"]*)">(.*?)</objectgroup>#sg`).exec(contents)
// print m; terminate()
var groupNames = ["entities"]
map.groups = {}
for(var i, name in m[1]){
	var group = {name = name}
	var objects = group.objects = []
	
	var groupContents = m[2][i]
	var mo = Regexp(`#<object\s+([^>]+)>(.*?)</object>#sg`).exec(groupContents)
	for(var io, obj in mo[1]){
		/* print obj; terminate()
		obj = obj.replace(Regexp(`#<properties>(.*?)</properties>#s`), function(m){
			return ""
		}) */
		objects[] = parseObject(obj)
	}
	
	var mo = Regexp(`#<object\s+([^>]+)/>#sg`).exec(groupContents)
	// print mo; // terminate()
	for(var io, obj in mo[1]){
		objects[] = parseObject(obj)
	}
	
	if(group.name in groupNames){
		map.groups[group.name] && throw "${group.name} objectgroup is already exist"
		map.groups[group.name] = group
	}else{
		print "skip unknown objectgroup: ${group}"
	}
}
for(var _, name in groupNames){
	map.groups[name] || throw "${name} objectgroup is not found in ${filename}"
}
isPlayerExist || throw "player is not found"

// print "map"; terminate()

var layerNames = ["front", "back", "items"]

map.layers = {}
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

	var data = Buffer()
	var tileset, offs = map.tilesets[layer.name], 0
	for(var y = 0; y < height; y++){
		for(var x = 0; x < width; x++){
			var gid = memdata.sub(offs, 4).unpack("V")
			if(gid > 0){
				gid = gid - tileset.firstgid
				if(gid == 0 && layer.name == "front"){
					map.floor && throw "layer ${layer.name} more than one floor at ${x}x${y}"
					map.floor = y+1
				}else if(gid <= 0 || gid > tileset.count){
					throw "layer ${layer.name} uses error tileset at ${x}x${y}"
				}
				if(gid > 0xffff){
					throw "layer ${layer.name} has error gid (${gid} > 0xffff) at ${x}x${y}"
				}
			}
			data << "v".pack(gid)
			offs += 4
		}
	}
	layer.data = zlib.gzcompress(toString(data))
	layer.data = base64.encode(layer.data)

	if(layer.name in layerNames){
		map.layers[layer.name] && throw "layer ${layer.name} is already exist"
		map.layers[layer.name] = layer
	}else{
		print "skip unknown layer: ${layer}"
	}
}

for(var _, name in layerNames){
	map.layers[name] || throw "${name} layer is not found in ${filename}"
}
map.floor || throw "floor is not set in front layer"

// print map; terminate()

var filename = "../data/levels/"..path.basename(filename).lower().replace(".tmx", ".json")
File.writeContents(filename, json.encode(map))
print "${filename} saved, layers: ${#map.layers}, tilesets: ${#map.tilesets}, entities: ${#map.groups.entities.objects}"

var levels = {}
for(var _, filename in fs.readdir("../data/levels")){
	if(path.extname(filename) != ".json"){
		print "found error level file: \"../data/levels/${filename}\""
		continue
	}
	levels[filename.replace(".json", "")] = "levels/${filename}"
}
var filename = "../data/levels.os"
var data = <<<END"
/* auto generated file */
return ${json.encode(levels)}
END
File.writeContents(filename, data)

print "${filename} updated, levels: ${#levels}"

print "= END ==============================\n"
