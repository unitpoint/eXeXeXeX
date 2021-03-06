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
var itemsTileset = map.tilesets.items
// print "entities tileset: ${map.tilesets.entities}"; terminate()
var parseObject = function(obj){
	obj = fixNumbers(parseAttributes(obj))
	// print obj; // terminate()
	if(obj.gid >= itemsTileset.firstgid && obj.gid < itemsTileset.firstgid + itemsTileset.count){
		obj.gid == itemsTileset.firstgid && throw "item should not use the first tileset gid: ${obj}"
		obj.objType = "item"
		obj.gid = obj.gid - itemsTileset.firstgid
	}else if(obj.gid >= entitiesTileset.firstgid && obj.gid < entitiesTileset.firstgid + entitiesTileset.count){
		obj.gid == entitiesTileset.firstgid && throw "entity should not use the first tileset gid: ${obj}"
		// obj.objType = "entity"
		obj.gid = obj.gid - entitiesTileset.firstgid
	}else{
		throw "error tileset gid: ${obj}"
	}
	obj.x = math.round(obj.x / map.tilewidth)
	obj.y = math.round(obj.y / map.tileheight - 1)
	if(obj.gid == 3){
		isPlayerExist && throw "there are more than one player at ${obj}"
		isPlayerExist = true
	}
	// print obj; // terminate()
	return obj
}

function parseSize(text){
	var mo = Regexp(`#^(\d+)x(\d+)$#s`).exec(text)
	// print "parseSize: ${text}, ${mo}"
	var x, y = toNumber(mo[1]), toNumber(mo[2])
	"${x}" == mo[1] || throw "error size parsing of width: ${text}"
	"${y}" == mo[2] || throw "error size parsing of height: ${text}"
	return {x=x, y=y}
}

function parseItems(text){
	var items = []
	for(var _, itemInfo in text.split(",")){
		var typeInfo, countInfo = itemInfo.split(":").unpack()
		var type, count = toNumber(typeInfo), toNumber(countInfo || 1)
		"${type}" == typeInfo || throw "error item type: ${text}"
		if(countInfo){
			"${count}" == countInfo || throw "error item count: ${text}"
		}
		items[] = {type=type, count=count}
	}
	return items
}

var m = Regexp(`#<objectgroup name="([^"]*)">(.*?)</objectgroup>#sg`).exec(contents)
// print m; terminate()
var groupNames = ["entities"]
map.groups = {}
for(var i, name in m[1]){
	var group = {name = name}
	var objects = group.objects = []
	
	var groupContents = m[2][i]
	groupContents = groupContents.replace(Regexp(`#<object\s+([^>]+)/>#s`), function(m){
		// print m
		objects[] = parseObject(m[1])
		return ""
	})
	
	groupContents = groupContents.replace(Regexp(`#<object\s+([^>]+)>(.*?)</object>#sg`), function(m){
		// print "prop obj: ${m}"
		var obj = parseObject(m[1])
		objects[] = obj
		
		var mo = Regexp(`#<property\s+([^>]+)/>#sg`).exec(m[2])
		for(var _, propText in mo[1]){
			// print "begin prop: ${propText}"
			var prop = fixNumbers(parseAttributes(propText))
			prop.name || throw "error prop name: ${propText}"
			obj[prop.name] && throw "prop is alredy used: ${propText} in ${obj}"
			switch(prop.name){
			case "size":
				obj.size = parseSize(prop.value)
				break
				
			case "items":
				obj.items = parseItems(prop.value)
				break
				
			default:
				throw "unknown prop: ${prop} in ${m}"
				obj[prop.name] = prop.value
			}
		}
		return ""
	})
	// print objects; terminate()
	
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

layers = {}
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
	layer.data = data
	// layer.data = zlib.gzcompress(toString(data))
	// layer.data = url.encode(layer.data) // base64 bugged on android
	// map.encoder = "url"

	if(layer.name in layerNames){
		layers[layer.name] && throw "layer ${layer.name} is already exist"
		layers[layer.name] = layer
	}else{
		print "skip unknown layer: ${layer}"
	}
}

for(var _, name in layerNames){
	layers[name] || throw "${name} layer is not found in ${filename}"
}
map.floor || throw "floor is not set in front layer"

// print map; terminate()

var filename = "../data/levels/"..path.basename(filename).lower().replace(".tmx", ".json")
File.writeContents(filename, json.encode(map))

var dataPrefix = "level-layers:front:back:items."
var buf = Buffer()
buf << dataPrefix
buf << layers.front.data
buf << layers.back.data
buf << layers.items.data
var data = zlib.gzcompress(buf)
File.writeContents(filename.replace(".json", ".bin"), data)

print "${filename} saved, layers: ${#layers}, tilesets: ${#map.tilesets}, entities: ${#map.groups.entities.objects}"

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
var data = <<<END"
/* auto generated file */
return ${json.encode(levels)}
END
File.writeContents(filename, data)

print "${filename} updated, levels: ${#levels}"

print "= END ==============================\n"
