require "std"

print "============================="
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

function extractAttributes(str){
	var m = Regexp(`/([\w\d_]+)=\"([^\"]*)\"/g`).exec(str)
	var r = {}
	for(var i, v in m[1]){
		r[v] = m[2][i]
	}
	return r
}

var contents = File.readContents(filename)
var m = Regexp(`/<map\s+(.+?)>/`).exec(contents)
var map = extractAttributes(m[1])

map.tilesets = {}
var m = Regexp(`#<tileset\s+([^>]+)>(.*?)</tileset>#sg`).exec(contents)
// print m
for(var i, v in m[1]){
	var tileset = extractAttributes(v)
	for(var name, value in tileset){
		var num = toNumber(value)
		if("${num}" == value){
			tileset[name] = num
		}
	}
	map.tilesets[tileset.name] = tileset
}

TILE_EMPTY_GID = 255

function convertToMapGid(gid){
	gid == 0 && return TILE_EMPTY_GID;
	return gid - map.tilesets.tiles.firstgid
}

function convertToEntityGid(gid){
	gid == 0 && return null;
	return gid - map.tilesets.entities.firstgid
}

map.layers = {}
var m = Regexp(`#<layer\s+([^>]+)>(.*?)</layer>#sg`).exec(contents)
for(var i, v in m[1]){
	var layer = extractAttributes(v)
	
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
	if(layer.name == "map"){
		for(var y = 0; y < height; y++){
			for(var x = 0; x < width; x++){
				gid = convertToMapGid(memdata.sub(offs, 4).unpack("V"))
				// print "gid ${gid} as ${x}x${y}"
				data << (i > 0 ? (i % 70 == 0 ? ",\n" : ",") : "")
				data << (gid == TILE_EMPTY_GID ? "E" : gid)
				offs += 4
				i++
			}
		}
		layer.cppMap = data
		
	}else if(layer.name == "entities"){
		for(var y = 0; y < height; y++){
			for(var x = 0; x < width; x++){
				gid = convertToEntityGid(memdata.sub(offs, 4).unpack("V"))
				if(gid){
					i++ > 0 && (data << ",\n")
					data << "{${x}, ${y}, ${gid}}"
				}
				offs += 4
			}
		}
		layer.cppEntities = data
		map.numEntities = i
	}
	
	map.layers[layer.name] = layer
}

// print map
var levelName = path.basename(filename).replace(".tmx", "")
var out = Buffer()
out << "#define E ${TILE_EMPTY_GID}\n\n"
for(var i, layer in map.layers){
	if(layer.cppEntities){
		out << "const Tiledmap::Entity ${levelName}LevelEntities[] = {\n"
		out << layer.cppEntities
		out << "\n};\n\n"
		continue
	}
	if(layer.cppMap){
		out << "const unsigned char ${levelName}LevelMap[] = {\n"
		out << layer.cppMap
		out << "\n};\n\n"
		continue
	}
	throw "unknown layer: ${layer}"
}
out << <<<END"
const Tiledmap ${levelName}Tiledmap = {
	{${map.width}, ${map.height}}, /* size */
	${levelName}LevelEntities, ${map.numEntities}, /* numEntities */
	${levelName}LevelMap
};

#undef E

END

var filename = "..\..\src\level_"..levelName..".inc"
File.writeContents(filename, out)
print "${filename} saved, layers: ${#map.layers}, tilesets: ${#map.tilesets}\n"
// print "${map}\n"

