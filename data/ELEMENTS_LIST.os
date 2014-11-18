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
ELEMENTS_LIST[ELEM_TYPE_TILE_OUTSIDE_UP] = ELEMENTS_LIST[ELEM_TYPE_EMPTY]

ELEMENTS_LIST[ELEM_TYPE_ENT_PLAYER].merge {
	class = "NewPlayer",
}

ELEMENTS_LIST[81].merge {
	class = "TileLadderItem",
}

ELEMENTS_LIST[89].merge {
	class = "TileLadderItem",
}

ELEMENTS_LIST[193].merge {
	class = "TileLadderItem",
}

ELEMENTS_LIST[82].merge {
	class = "TileDoorItem",
	doorCastShadow = true,
	doorSideSensorSize = TILE_SIZE * 0.5,
	doorHandleOpenAngle = -360*2.3,
	doorHandle = "door-handle",
	doorHandlePivot = vec2(0.51, 0.51),
	// doorHandleScale = 0.6,
	doorHandleShadow = "door-handle-shadow",
	// doorOpenSound = "open",
	// doorCloseSound = "open",
}

ELEMENTS_LIST[97].merge {
	class = "TileDoorItem",
	doorCastShadow = true,
	doorSideSensorSize = TILE_SIZE * 0.5,
	doorHandleOpenAngle = -360*2.3,
	doorHandle = "door-handle",
	doorHandlePivot = vec2(0.51, 0.51),
	doorHandleScale = 0.6,
	doorHandleShadow = "door-handle-shadow",
	// doorOpenSound = "open",
	// doorCloseSound = "open",
}

ELEMENTS_LIST[212].merge {
	class = "TileDoorItem",
	doorCastShadow = true,
	doorSideSensorSize = TILE_SIZE * 0.5,
	doorMoveDir = vec2(-1, 0),
	// doorOpenTime = 1.0,
	// doorCloseTime = 1.0,
	// doorHandleOpenTime = 1.0
	// doorHandleCloseTime = 1.0
	doorHandleOpenAngle = -360*2.3,
	doorHandle = "door-handle",
	doorHandlePivot = vec2(0.51, 0.51),
	doorHandleScale = 0.6,
	doorHandleShadow = "door-handle-shadow",
	// doorOpenSound = "open",
	// doorCloseSound = "open",
}

ELEMENTS_LIST[213].merge {
	class = "TileDoorItem",
	doorCastShadow = true,
	doorSideSensorSize = TILE_SIZE * 0.5,
	doorMoveDir = vec2(1, 0),
	// doorOpenTime = 1.0,
	// doorCloseTimeout = 1.0,
	// doorCloseTime = 1.0,
	// doorHandleOpenTime = 1.0,
	// doorHandleCloseTime = 1.0,
	doorHandleOpenAngle = -360*2.3,
	doorHandle = "door-handle",
	doorHandlePivot = vec2(0.51, 0.51),
	doorHandleScale = 0.6,
	doorHandleShadow = "door-handle-shadow",
	// doorOpenSound = "open",
	// doorCloseSound = "open",
}

ELEMENTS_LIST[84].merge {
	class = "TileDoorItem",
	doorCastShadow = false,
	doorSideSensorSize = TILE_SIZE * 2.0,
	doorOpenTime = 0.3,
	doorCloseTime = 1.0,
}

ELEMENTS_LIST[98].merge {
	class = "TileDoorItem",
	doorCastShadow = false,
	doorSideSensorSize = TILE_SIZE * 2.0,
	doorOpenTime = 0.15,
	doorCloseTimeout = 0.3,
	doorCloseTime = 0.8,
}

ELEMENTS_LIST[172].merge {
	class = "TileLightItem",
	lightResName = "light-table-lamp",
	lightRadius = TILE_SIZE * 3,
	lightColor = Color(1.0, 1.0, 0.7),
	// lightFrontColor = [0, 0, 0],
}

ELEMENTS_LIST[173].merge {
	class = "TileLightItem",
	lightResName = "light-tunel-lamp",
	// lightRadius = TILE_SIZE * 8,
	lightColor = Color(1.0, 1.0, 0.8),
	// lightFrontColor = [0, 0, 0],
}

ELEMENTS_LIST[174].merge {
	class = "TileLightItem",
	lightResName = "light-alarm-lamp",
	// lightRadius = TILE_SIZE * 8,
	lightColor = Color(1.0, 0.5, 0.4),
	lightAngularVelocity = 360 * 0.5,
	// lightFrontColor = [0, 0, 0],
}

ELEMENTS_LIST[211].merge {
	class = "TileLightItem",
}

ELEMENTS_LIST[264].merge {
	class = "TilePlatformItem",
	// platformPhysSizeScale = vec2(0.98, 1),
	platformPhysA = vec2(0.01171875, 0),
	platformPhysB = vec2(1 - 0.01171875, 0.6875),
	platformCastShadow = true,
}

ELEMENTS_LIST[265].merge {
	class = "TilePlatformItem",
	// platformPhysSizeScale = vec2(0.98, 1),
	platformPhysA = vec2(0, 0),
	platformPhysB = vec2(1, 0.7),
	platformPhysCellSize = vec2(26 / 256, 26 / (64 * 0.7)),
	platformPhysCellCount = 6,
	platformCastShadow = true,
}

ELEMENTS_LIST[266].merge {
	class = "TilePlatformItem",
	// platformPhysSizeScale = vec2(0.98, 1),
	platformPhysA = vec2(0, 0),
	platformPhysB = vec2(1, 0.7),
	platformPhysCellSize = vec2(13 / 256, 13 / (64 * 0.7)),
	platformPhysCellCount = 10,
	platformCastShadow = true,
}

ELEMENTS_LIST[267].merge {
	class = "TilePlatformItem",
	// platformPhysSizeScale = vec2(0.98, 1),
	platformPhysA = vec2(0, 0),
	platformPhysB = vec2(1, 0.58),
	platformPhysCellSize = vec2(6 / 256, 6 / (64 * 0.58)),
	platformPhysCellCount = 16,
	platformPhysCellTiled = true,
	platformCastShadow = true,
}

ELEMENTS_LIST[57].merge {
	isLiftShaft = true,
}

// print ELEMENTS_LIST; terminate()