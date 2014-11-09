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

HudSlot = extends ItemSlot {
	__construct = function(game, slotNum){
		super(game, Backpack, slotNum)
		@opacity = 0.75
		@selectedSprite = null
	},
	
	cleanup = function(){
		@isSelected = false
		super()
	},
	
	select = function(){
		if(!@selectedSprite){
			print "select hud slot: ${@slotNum}"
			@game.selectedHudSlot.deselect()
			@game.selectedHudSlot = this
			@selectedSprite = Sprite().attrs {
				resAnim = res.get("slot-border-selected"),
				pivot = vec2(0.5, 0.5),
				pos = @pos + @size * (0.5 - @pivot),
				scale = @scale,
				parent = @parent,
				touchEnabled = false,
			}
		}
	},
	
	deselect = function(){
		if(@selectedSprite){
			print "deselect hud slot: ${@slotNum}"
			@selectedSprite.detach()
			@selectedSprite = null
			@game.selectedHudSlot = null
		}
	},
	
	__get@isSelected = function(){
		return @game.selectedHudSlot === this
	},
	
	__set@isSelected = function(value){
		if(value != @isSelected){
			@game.selectedHudSlot.deselect()
			value && @select()
		}
	},
	
	__set@type = function(type){
		@clearItem()
		var pickDamage = type in PICK_DAMAGE_ITEMS_INFO
		// var ladders = type in LADDERS_ITEMS_INFO
		for(var _, hudSlot in @game.hudSlots){
			if(hudSlot.type == type){
				hudSlot.clearItem()
			}else if(pickDamage && hudSlot.type in PICK_DAMAGE_ITEMS_INFO){
				hudSlot.clearItem()
			//}else if(ladders && hudSlot.type in LADDERS_ITEMS_INFO){
			//	hudSlot.clearItem()
			}
		}
		super(type)
		if(pickDamage){
			Player.pickItemType = type
			print "Player.pickItemType: ${Player.pickItemType}, damage: ${PICK_DAMAGE_ITEMS_INFO[Player.pickItemType].pickDamage}"
		}
		/* if(ladders){
			Player.laddersItemType = type
			print "Player.laddersItemType: ${Player.laddersItemType}"
		} */
		@count = @owner.pack.numItemsByType[type]
	},
	
	clearItem = function(){
		@isSelected = false
		switch(@type){
		case null:
			break
			
		case Player.pickItemType:
			Player.pickItemType = null
			print "clear Player.pickItemType"
			break
			
		/* case Player.laddersItemType:
			Player.laddersItemType = null
			print "clear Player.laddersItemType"
			break */
		}
		super()
	},
	
	updateItem = function(){
		var count = @owner.pack.numItemsByType[@type]
		if(count > 0){
			@count = count
		}else{
			@clearItem()
		}
	},
	
	useItem = function(){
		var type = @type || return;
		if(type == Player.pickItemType){
			
		}else{ // if(ITEMS_INFO[type].useDistance > 0){
			@game.player.useItem(type)
		}
	},
}