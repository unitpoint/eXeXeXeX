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

ELEMENTS_LIST[ELEM_TYPE_TILE_OUTSIDE] = ELEMENTS_LIST[7]

// print ELEMENTS_LIST; terminate()