/******************************************************************************
* Copyright (C) 2014 Evgeniy Golovin (evgeniy.golovin@unitpoint.ru)
*
* Please feel free to contact me at anytime, 
* my email is evgeniy.golovin@unitpoint.ru, skype: egolovin
*
* eXeXeXeX is a 4X genre of strategy-based video game in which player 
* "eXplore, eXpand, eXploit, and eXterminate" the world
* 
* Latest source code
*	eXeXeXeX: https://github.com/unitpoint/eXeXeXeX
* 	OS2D engine: https://github.com/unitpoint/os2d
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************/

ItemsPack = extends Object {
	__object = {
		items = {}, // by slot num
		numItemsByType = {},
		// numSlots = 0,
	},
	
	__construct = function(numSlots){
		super()
		@numSlots = numSlots || 3*3
	},
	
	hasItem = function(type){
		return !!@numItemsByType[type]
	},
	
	addItem = function(type, count){
		count || count = 1
		for(var _, item in @items){
			if(item.type == type){
				item.count = (item.count || throw "error item count: ${item}") + count
				@updateNumItems()
				return true
			}
		}
		for(var i = 0; i < @numSlots; i++){
			if(i in @items == false){
				@items[i] = {
					type = type,
					count = count,
				}
				@updateNumItems()
				return true
			}
		}
		return false
	},
	
	removeSlotItems = function(slotNum){
		delete @items[slotNum]
		@updateNumItems()
	},
	
	updateNumItems = function(){
		@numItemsByType = {}
		for(var _, item in @items){
			var count = @numItemsByType[item.type] || 0
			@numItemsByType[item.type] = count + item.count
		}
	},
	
	updateActorItems = function(actor, startSlotNum, count){
		@updateNumItems()
		for(var _, slot in actor.slots){
			slot.clearItem()
		}
		startSlotNum || startSlotNum = 0
		count || count = #actor.slots
		var endSlotNum = startSlotNum + count
		for(var slotNum = startSlotNum; slotNum < endSlotNum; slotNum++){
		// for(var slotNum, item in @items){
			var item = @items[slotNum] || continue
			var slot = actor.slots[slotNum] || continue
			slot.type = item.type
			slot.count = item.count
		}
	},
}