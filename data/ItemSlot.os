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

ItemSlot = extends Box9Sprite {
	__construct = function(game, owner, slotNum, resName){
		super()
		@game = game
		@owner = owner
		@slotNum = slotNum
		// @sumCount = sumCount
		@resAnim = res.get(resName || "slot")
		@size = vec2(SLOT_SIZE, SLOT_SIZE)
		@touchChildrenEnabled = false
		// @countEnabled = true
		// @spriteOpacity = 1
		@sprite = @countText = @_type = @_count = null
	},

	clearItem = function(){
		@removeChildren()
		@sprite = @countText = @_type = @_count = null
	},
	
	__get@isEmpty = function(){
		return !@sprite
	},
	
	__get@type = function(){
		return @_type
	},
	
	__set@type = function(type){
		@_type === type && return;
		// @clearItem()
		@_type = type
		@sprite.detach(); @sprite = null
		type && type != ITEM_TYPE_EMPTY && @sprite = Sprite().attrs {
			resAnim = res.get(@game.getSlotItemResName(type)),
			pivot = vec2(0.5, 0.5),
			pos = @size/2,
			priority = 1,
			parent = this,
			touchEnabled = false, // it will be detached while drgging
			// opacity = @spriteOpacity,
		}
	},
	
	__get@count = function(){
		return @_count // || (@sumCount ? @owner.pack.numItemsByType[@type] : @owner.pack.items[@slotNum].count)
	},
	
	__set@count = function(value){
		@_count === value && return;
		@_count = value
		@countText.detach(); @countText = null
		value && @countText = TextField().attrs {
			resFont = res.get("test"),
			vAlign = TEXT_VALIGN_BOTTOM,
			hAlign = TEXT_HALIGN_RIGHT,
			text = value,
			pos = @size - vec2(4, 5),
			priority = 2,
			parent = this,
		}
	},
	
	/* update = function(){
		var count = @count
		if(count > 0){
			@countEnabled && @countText.text = count
		}else{
			@clearItem()
		}
	}, */
}
