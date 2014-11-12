require "consts"

ELEMENTS_LIST = {
}

startElementType = 0

function addElement(elem){
	elem.type || throw "type is not set in ${elem}"
	elem.type = elem.type + startElementType
	var curElement = ELEMENTS_LIST[elem.type]
	if(curElement){
		throw "element is already exist: ${curElement}, all list: ${ELEMENTS_LIST}"
	}else{
		ELEMENTS_LIST[elem.type] = elem
	}
	return elem
}

function extendElement(elem){
	elem.type || throw "type is not set in ${elem}"
	elem.type = elem.type + startElementType
	var curElement = ELEMENTS_LIST[elem.type]
	if(curElement){
		curElement.merge(elem)
	}else{
		ELEMENTS_LIST[elem.type] = elem
	}
	return elem
}

addElement {
	type = ELEM_TYPE_EMPTY,
	isTile = true,
	transparent = true,
	res = "tile-64x64-000",
	/*
	ingridients = {
		ELEM_TYPE_1 = COUNT_1,
		ELEM_TYPE_2 = COUNT_2,
		ELEM_TYPE_3 = COUNT_3,
	},
	*/
}

// print require("resElements")

for(var _, elem in require("resElements")){
	if(!elem.strength && elem.isTile){
		elem.strength = 4
	}
	addElement(elem)
}

/* if("Color" in _E){
// var color = Color(0.5, 0.5, 0.5, 1)
var color = Color(1.1, 1.1, 1.1, 1)
ELEMENTS_LIST[24].color = Color.fromInt(0x346b8c) * color
ELEMENTS_LIST[25].color = Color.fromInt(0xf3f7e5) * color
ELEMENTS_LIST[26].color = Color.fromInt(0xcc863d) * color
} */

ELEMENTS_LIST[ELEM_TYPE_TILE_OUTSIDE] = ELEMENTS_LIST[7]

ELEMENTS_LIST[ELEM_TYPE_ENT_PLAYER].merge {
	class = "NewPlayer",
}

ELEMENTS_LIST[ELEM_TYPE_ITEM_LADDER].merge {
	class = "TileLadderItem",
}

ELEMENTS_LIST[82].merge {
	class = "TileUpHandleDoorItem",
	handle = "door-handle",
	handleShadow = "door-handle-shadow",
}

ELEMENTS_LIST[97].merge {
	class = "TileUpHandleDoorItem",
	handle = "door-handle",
	handleScale = 0.6,
	handleShadow = "door-handle-shadow",
}

ELEMENTS_LIST[84].merge {
	class = "TileUpDoorItem",
}

ELEMENTS_LIST[98].merge {
	class = "TileUpDoorItem",
}

ELEMENTS_LIST[172].merge {
	class = "TileLightItem",
	lightResName = "light-table-lamp",
	lightRadius = TILE_SIZE * 3,
	lightColor = [1.0, 1.0, 0.7],
}

ELEMENTS_LIST[173].merge {
	class = "TileLightItem",
	lightResName = "light-tunel-lamp",
	// lightRadius = TILE_SIZE * 8,
	lightColor = [1.0, 1.0, 0.8],
}

ELEMENTS_LIST[174].merge {
	class = "TileLightItem",
	lightResName = "light-alarm-lamp",
	// lightRadius = TILE_SIZE * 8,
	lightColor = [1.0, 0.5, 0.4],
	lightAngularVelocity = 360 * 0.5,
}

ELEMENTS_LIST[211].merge {
	class = "TileLightItem",
}

// print ELEMENTS_LIST; terminate()