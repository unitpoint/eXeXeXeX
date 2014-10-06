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

DragndropItems = extends Actor {
	__construct = function(game){
		super()
		@game = game
		@touchEnabled = false
		
		var findTargetFunc, handleDragndrop
		
		@mode = null
		@itemSelected = @itemSlot = @touchPos = @targetSlot = null
		
		@startEventId = stage.addEventListener(TouchEvent.START, function(ev){
			if(ev.target is ItemSlot){
				if(ev.target is HudSlot){
					@mode = "hud"
					findTargetSlot = @findHudTargetSlot.bind(this)
					handleDragndrop = @handleHudDragndrop.bind(this)
				}else if(ev.target.owner is Backpack){
					@mode = "backpack"
					findTargetSlot = @findBackpackTargetSlot.bind(this)
					handleDragndrop = @handleBackpackDragndrop.bind(this)
				}else if(ev.target.owner is Shop && ev.target is TargetSlot == false){
					@mode = "shop"
					findTargetSlot = @findShopTargetSlot.bind(this)
					handleDragndrop = @handleShopDragndrop.bind(this)
				}else{
					throw "unknown item owner: ${ev.target.owner.classname}"
				}
				
				// @extendedClickArea = stage.width
				@itemSlot = ev.target
				@itemSelected = @itemSlot.sprite
				@targetSlot = null
				
				// itemSelected.touchEnabled = false
				@itemSelected.color = Color(0.9, 0.9, 0.99)
				// print "${itemSelected.pos} == ${itemSelected.localToLocal(itemSelected.pos, itemSlot)}"
				// itemSelected.pos = itemSelected.localToLocal(@parent)
				// itemSelected.parent = @parent
				@itemSelected.changeParentAndSavePos(stage)
				
				if(@mode == "backpack" && @game.shop){
					@game.shop.showSell(@itemSlot)
				}else if(@mode == "shop"){
					@game.shop.showBuy(@itemSlot)
				}
				
				@touchPos = stage.localToGlobal(ev.localPos)
			}
		})

		@moveEventId = stage.addEventListener(TouchEvent.MOVE, function(ev){
			if(@itemSelected){ // ev.target.name == "backpackSlot"){
				// print "move: "..ev.localPos
				var curTouchPos = stage.localToGlobal(ev.localPos)
				var delta = curTouchPos - @touchPos
				@touchPos = curTouchPos
				
				@itemSelected.pos += delta
				
				var slot = stage.findActorByPos(curTouchPos, findTargetSlot)
				if(slot !== @targetSlot){
					@targetSlot = slot
					if(slot){
						slot.color = Color.WHITE
						var action = EaseAction(TweenAction {
							duration = 0.5,
							color = Color(1, 0.4, 0.4),
						}, Ease.PING_PONG)
						action.name = "selectTargetSlot"
						slot.replaceAction(action)
					}
				}
			}
		})
		
		@endEventId = stage.addEventListener(TouchEvent.END, function(ev){
			if(@itemSelected){ // ev.target.name == "backpackSlot"){
				if(@mode == "backpack" && @game.shop){
					// @game.shop.targetSlot.clearItem()
					@game.shop.endShowSell()
				}
				if(!@targetSlot || @targetSlot == @itemSlot){
					@itemSelected.pos = @itemSlot.size/2
					@itemSelected.parent = @itemSlot
					@itemSelected.color = Color.WHITE
					@itemSelected = null
				}else{
					handleDragndrop()
				}
				@itemSelected = @itemSlot = @targetSlot = null
				// @extendedClickArea = 0
			}
		})
	},
	
	findBackpackTargetSlot = function(slot){
		return slot is HudSlot 
			|| (slot is TargetSlot && slot.owner is Shop)
			|| (slot is ItemSlot && slot.owner is Backpack)
	},
	
	handleBackpackDragndrop = function(){
		var owner = @itemSlot.owner as Backpack || throw "Backpack required"
		if(@targetSlot is TargetSlot){
			var shop = @targetSlot.owner as Shop || throw "Shop required"
			var itemInfo = owner.pack.items[@itemSlot.slotNum]
			itemInfo.type == @itemSlot.type || throw "mismatch item type: ${itemInfo.type} != ${@itemSlot.type}"
			itemInfo.count == @itemSlot.count || throw "mismatch item count: ${itemInfo.count} != ${@itemSlot.count}"
			
			Player.bullets = Player.bullets + shop.getSellPriceByType(itemInfo.type) * itemInfo.count
			owner.updateBullets()
			
			delete owner.pack.items[@itemSlot.slotNum]
			@itemSelected.detach()
			owner.updateItems()
			shop.resetTargetSlot()
		}else if(@targetSlot is HudSlot){
			var itemInfo = owner.pack.items[@itemSlot.slotNum]
			@targetSlot.type = itemInfo.type
			@itemSelected.pos = @itemSlot.size/2
			@itemSelected.parent = @itemSlot
			@itemSelected.color = Color.WHITE
			if(itemInfo.type in PICK_DAMAGE_ITEMS_INFO){
				for(var _, slot in @game.hudSlots){
					if(slot !== @targetSlot && slot.type in PICK_DAMAGE_ITEMS_INFO){
						slot.clearItem()
					}
				}
				Player.pickItemType = itemInfo.type
			}else{
				Player.pickItemType = null
				for(var _, slot in @game.hudSlots){
					if(slot.type in PICK_DAMAGE_ITEMS_INFO){
						Player.pickItemType = slot.type
						break
					}
				}
			}
		}else{
			var itemInfo = owner.pack.items[@itemSlot.slotNum]
			var targetItemInfo = owner.pack.items[@targetSlot.slotNum]
			if(!targetItemInfo){
				var moveCount = math.ceil(itemInfo.count / 2)
				if(moveCount == itemInfo.count){
					owner.pack.items[@targetSlot.slotNum] = itemInfo
					delete owner.pack.items[@itemSlot.slotNum]
				}else{
					owner.pack.items[@targetSlot.slotNum] = {
						type = itemInfo.type,
						count = moveCount,
					}
					itemInfo.count -= moveCount
				}
			}else if(targetItemInfo.type == itemInfo.type){
				var moveCount = itemInfo.count
				targetItemInfo.count += moveCount
				delete owner.pack.items[@itemSlot.slotNum]
			}else{
				owner.pack.items[@itemSlot.slotNum] = targetItemInfo
				owner.pack.items[@targetSlot.slotNum] = itemInfo
			}
			// var backpack = @findParentOf(@itemSlot, Backpack)
			@itemSelected.detach()
			owner.updateItems()
			@game.shop && @game.shop.showSell(@targetSlot)
		}
	
	},
	
	findShopTargetSlot = function(slot){
		return slot is ItemSlot
			&& (slot.isEmpty || slot.type == @itemSlot.type)
			&& slot.owner is Backpack 
			&& slot is HudSlot == false
	},
	
	handleShopDragndrop = function(){
		@itemSelected.pos = @itemSlot.size/2
		@itemSelected.parent = @itemSlot
		@itemSelected.color = Color.WHITE
	},
	
	findHudTargetSlot = function(actor){
		return (actor is ItemSlot && actor.owner is Backpack) || actor is HudSlot
	},
	
	handleHudDragndrop = function(){
		@itemSelected.pos = @itemSlot.size/2
		@itemSelected.parent = @itemSlot
		@itemSelected.color = Color.WHITE
	},
	
	cleanup = function(){
		stage.removeEventListener(@startEventId)
		stage.removeEventListener(@moveEventId)
		stage.removeEventListener(@endEventId)
	},
	
	findParentOf = function(actor, ClassType){
		for(; actor;){
			actor is ClassType && return actor;
			actor = actor.parent
		}
	},
}