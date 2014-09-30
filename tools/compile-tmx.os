require "std"

print "= BEGIN ============================"
// print process.argv

function usage(){
	print "Usage:"
	print "${process.argv[1]} filename.tmx"
	terminate()
}

var filename = process.argv[2]
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

map.layers = {}

var m = Regexp(`#<objectgroup name="([^"]*)">(.*?)</objectgroup>#sg`).exec(contents)
// print m; terminate()
var objects
var tileset = map.tilesets.entities
// print "entities tileset: ${tileset}, ${map.tilesets.keys}, ${map.tilesets.entities}"; terminate()
var parseObject = function(obj){
	obj = fixNumbers(parseAttributes(obj))
	// print obj; // terminate()
	obj.gid = obj.gid - tileset.firstgid
	if(obj.gid <= 0 || obj.gid > tileset.count){
		obj.gid = obj.gid + tileset.firstgid
		throw "entities uses error tileset at ${obj}"
	}
	var player = obj.type == "player"
	if(player){
		if(map.player){
			obj.gid = obj.gid + tileset.firstgid
			throw "layer ${layer.name} more than one player at ${obj}"
		}
		map.player = true
	}
	obj.x = math.round(obj.x / map.tilewidth)
	obj.y = math.round(obj.y / map.tileheight - 1)
	// print obj; // terminate()
	objects[] = "{${obj.x}, ${obj.y}, ${obj.gid}, ${player}}"
}
for(var i, groupName in m[1]){
	var layer = { name = groupName }
	var groupContents = m[2][i]
	var objects = []
	var mo = Regexp(`#<object\s+([^>]+)>(.*?)</object>#sg`).exec(groupContents)
	for(var io, obj in mo[1]){
		/* print obj; terminate()
		obj = obj.replace(Regexp(`#<properties>(.*?)</properties>#s`), function(m){
			return ""
		}) */
		parseObject(obj)
	}
	
	var mo = Regexp(`#<object\s+([^>]+)/>#sg`).exec(groupContents)
	// print mo; // terminate()
	for(var io, obj in mo[1]){
		parseObject(obj)
	}
	layer.cppEntities = objects.join(",\n")
	if(layer.name == "entities"){
		map.numEntities = #objects
	}
	map.layers[layer.name] && throw "layer ${layer.name} is already exist"
	map.layers[layer.name] = layer
}

// print "map"; terminate()

var m = Regexp(`#<layer\s+([^>]+)>(.*?)</layer>#sg`).exec(contents)
for(var i, v in m[1]){
	var layer = parseAttributes(v)
	
	var dm = Regexp(`#<data encoding="base64" compression="zlib">(.*?)</data>#s`).exec(m[2][i])
	// print dm[1].trim()
	var memdata = base64.decode(dm[1].trim())
	// print "memdata: ${memdata}"
	memdata = zlib.gzuncompress(memdata)
	// print "memdata2: ${memdata}"
	
	var width = toNumber(layer.width)
	var height = toNumber(layer.height)
	if(!map.width){
		map.width = width
		map.height = height
	}else{
		map.width == width || throw "layer: ${layer.name} width ${width} != map width ${map.width}"
		map.height == height || throw "layer: ${layer.name} height ${height} != map height ${map.height}"
	}

	var i, offs = 0, 0
	var data = Buffer()
	if(layer.name in ["front", "back", "items"]){
		var tileset = map.tilesets[layer.name]
		for(var y = 0; y < height; y++){
			for(var x = 0; x < width; x++){
				gid = memdata.sub(offs, 4).unpack("V")
				if(gid > 0){
					gid = gid - tileset.firstgid
					if(gid < 0 || gid > tileset.count){
						throw "layer ${layer.name} uses error tileset at ${x}x${y}"
					}
					if(gid == 0 && layer.name == "front"){
						layer.floor && throw "layer ${layer.name} more than one floor at ${x}x${y}"
						layer.floor = y+1
					}
				}
				// gid || throw "error gid at ${x}x${y}, layer: ${layer.name}, ${map.tilesets[layer.name]}"
				// print "[${x}x${y}] gid ${gid}, layer: ${layer.name}, ${map.tilesets[layer.name]}"; terminate()
				data << (i > 0 ? (i % 70 == 0 ? ",\n" : ",") : "")
				data << gid
				offs += 4
				i++
			}
		}
		layer.cppMap = data
	/* }else if(layer.name == "entities"){
		for(var y = 0; y < height; y++){
			for(var x = 0; x < width; x++){
				gid = memdata.sub(offs, 4).unpack("V")
				gid > 0 && gid = gid - map.tilesets.entities.firstgid
				if(gid > 0){
					if(gid == 1){
						layer.player && throw "layer ${layer.name} more than one player at ${x}x${y}"
						layer.player = true
					}
					i++ > 0 && (data << ",\n")
					data << "{${x}, ${y}, ${gid}}"
				}
				offs += 4
			}
		}
		layer.cppEntities = data
		map.numEntities = i */
	}
	map.layers[layer.name] && throw "layer ${layer.name} is already exist"
	map.layers[layer.name] = layer
}

for(var _, name in ["front", "back", "entities", "items"]){
	map.layers[name] || throw "${name} layer is not found in ${filename}"
}
map.layers.front.floor || throw "floor is not set in front layer"
map.player || throw "player is not found"

// print map
var levelName = path.basename(filename).replace(".tmx", "")
var out = Buffer()
out << "#ifndef __TILEDMAP_LEVEL_${levelName.upper()}_H__\n"
out << "#define __TILEDMAP_LEVEL_${levelName.upper()}_H__\n"
for(var i, layer in map.layers){
	if(layer.cppEntities){
		out << "const Tiledmap::Entity ${levelName}EntitiesLayer[] = {\n"
		out << layer.cppEntities
		out << "\n};\n\n"
		continue
	}
	if(layer.cppMap){
		out << "const OS_BYTE ${levelName}${layer.name.flower()}Layer[] = {\n"
		out << layer.cppMap
		out << "\n};\n\n"
		continue
	}
	print "skip unknown layer: ${layer}"
}
out << <<<END"
const Tiledmap ${levelName}Tiledmap = {
	{${map.width}, ${map.height}}, /* size */
	${map.layers.front.floor}, /* floor */
	${levelName}EntitiesLayer, ${map.numEntities}, /* numEntities */
	${levelName}ItemsLayer,
	${levelName}FrontLayer,
	${levelName}BackLayer,
};

#endif // __TILEDMAP_LEVEL_${levelName.upper()}_H__

END

var filename = "..\src\level_"..levelName..".inc.h"
File.writeContents(filename, out)
print "${filename} saved, layers: ${#map.layers}, tilesets: ${#map.tilesets}, entities: ${map.numEntities}"
// print "${map}\n"

print "= END ==============================\n"
