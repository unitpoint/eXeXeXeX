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
		
		var startDragndrop, findTargetFunc, handleDragndrop, breakDragndrop
		
		@mode = null
		@itemSelected = @itemSlot = @touchPos = @targetSlot = null
		
		@shopSlotSelected = null
		@shopSkipBreakAction = true
		@shopTimeoutHandle = null
		
		@startEventId = stage.addEventListener(TouchEvent.START, function(ev){
			if(ev.target is ItemSlot){
				if(ev.target is HudSlot){
					@mode = "hud"
					startDragndrop = @startHudDragndrop.bind(this)
					findTargetSlot = @findHudTargetSlot.bind(this)
					handleDragndrop = @handleHudDragndrop.bind(this)
					breakDragndrop = @breakHudDragndrop.bind(this)
				}else if(ev.target.owner is Backpack){
					@mode = "backpack"
					startDragndrop = @startBackpackDragndrop.bind(this)
					findTargetSlot = @findBackpackTargetSlot.bind(this)
					handleDragndrop = @handleBackpackDragndrop.bind(this)
					breakDragndrop = @breakBackpackDragndrop.bind(this)
				}else if(ev.target.owner is Shop && ev.target is TargetSlot == false){
					@mode = "shop"
					startDragndrop = @startShopDragndrop.bind(this)
					findTargetSlot = @findShopTargetSlot.bind(this)
					handleDragndrop = @handleShopDragndrop.bind(this)
					breakDragndrop = @breakShopDragndrop.bind(this)
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
					// @game.shop.showSell(@itemSlot)
				}else if(@mode == "shop"){
					// @game.shop.showBuy(@itemSlot)
				}
				
				@touchPos = stage.localToGlobal(ev.localPos)
				startDragndrop()
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
					breakDragndrop()
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
	
	startBackpackDragndrop = function(){
		@game.shop.showSell(@itemSlot)
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
				print "Player.pickItemType: ${Player.pickItemType}, damage: ${PICK_DAMAGE_ITEMS_INFO[Player.pickItemType].pickDamage}"
			}else{
				Player.pickItemType = null
				for(var _, slot in @game.hudSlots){
					if(slot.type in PICK_DAMAGE_ITEMS_INFO){
						Player.pickItemType = slot.type
						print "Player.pickItemType: ${Player.pickItemType}, damage: ${PICK_DAMAGE_ITEMS_INFO[Player.pickItemType].pickDamage}"
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
			@itemSelected.detach()
			owner.updateItems()
			@game.shop && @game.shop.showSell(@targetSlot)
		}
	},
	
	breakBackpackDragndrop = function(){
	},
	
	clearShopItemCount = function(){
		@shopSlotSelected.count = null
		@shopSlotSelected = null
		/* if(@shopItemSelected && "countText" in @shopItemSelected){
			@shopItemSelected.countText.detach()
			delete @shopItemSelected.countText
			delete @shopItemSelected.count
			@shopItemSelected = null
		} */
	},
	
	updateShopPrice = function(){
		@itemSlot.count = (@itemSlot.count || 0) + 1
		var color = Color(0.5, 1, 0.5)
		var sumPrice = ITEMS_INFO[@itemSlot.type].price * @itemSlot.count
		if(sumPrice > Player.bullets){ // && @itemSelected.count > 1){
			var count = @itemSlot.count - 1
			@itemSlot.count = count > 0 ? count : null
			color = Color.WHITE // fromInt(0xf9a288) // Color(1, 0.7, 0.7)
		}
		@game.shop.showBuy(@itemSlot, @itemSlot.count, color)
	},
	
	startShopDragndrop = function(){
		@shopSkipBreakAction = false
		if(@shopSlotSelected !== @itemSlot){
			@clearShopItemCount()
			@shopSlotSelected = @itemSlot
			@updateShopPrice()
			@shopSkipBreakAction = true
		}else{
			// @game.shop.showBuy(@itemSlot, @itemSlot.count)
		}
		@removeTimeout(@shopTimeoutHandle)
		
		var startWait = 0.5
		var delta = startWait
		var updateShopPrice = function(){
			@updateShopPrice()
			@shopSkipBreakAction = true
			
			delta = math.max(0.07, delta == startWait ? 0.2 : delta * 0.9)
			@shopTimeoutHandle = @addTimeout(delta, updateShopPrice)
		}
		@shopTimeoutHandle = @addTimeout(delta, updateShopPrice)
		
		/* @shopItemSelected !== @itemSelected && @clearShopItemCount()
		@shopItemSelected = @itemSelected
		if("countText" in @itemSelected == false){
			@itemSelected.count = 1
			@itemSelected.countText = TextField().attrs {
				resFont = res.get("test"),
				vAlign = TEXT_VALIGN_BOTTOM,
				hAlign = TEXT_HALIGN_LEFT,
				// text = @itemSelected.count,
				pos = vec2(4, 20),
				priority = 2,
				parent = @itemSelected,
			}
			// @itemSelected.countText.y = @itemSelected.countText.textSize.y
		}else{
			// @itemSelected.countText.text = 
			++@itemSelected.count
		}
		var color = Color(0.5, 1, 0.5)
		var sumPrice = ITEMS_INFO[@itemSlot.type].price * @itemSelected.count
		if(sumPrice > Player.bullets){ // && @itemSelected.count > 1){
			--@itemSelected.count
			color = Color.WHITE // fromInt(0xf9a288) // Color(1, 0.7, 0.7)
		}
		@itemSelected.countText.text = @itemSelected.count > 0 ? @itemSelected.count : ""
		@game.shop.updateBuyText(@itemSlot, math.max(1, @itemSelected.count), color) */
	},
	
	breakShopDragndrop = function(){
		@removeTimeout(@shopTimeoutHandle); @shopTimeoutHandle = null
		if(!@shopSkipBreakAction){
			@updateShopPrice()
		}
	},
	
	findShopTargetSlot = function(slot){
		@removeTimeout(@shopTimeoutHandle); @shopTimeoutHandle = null
		@shopSkipBreakAction = true
		return slot is ItemSlot
			&& (slot.isEmpty || slot.type == @itemSlot.type)
			&& slot.owner is Backpack 
			&& slot is HudSlot == false
	},
	
	handleShopDragndrop = function(){
		@removeTimeout(@shopTimeoutHandle); @shopTimeoutHandle = null
		
		var shop = @itemSlot.owner as Shop || throw "Shop required"
		var backpack = @targetSlot.owner as Backpack || throw "Backpack required"
		
		var itemInfo = shop.pack.items[@itemSlot.slotNum]
		itemInfo.type == @itemSlot.type || throw "mismatch item type: ${itemInfo.type} != ${@itemSlot.type}"
		
		var count, valid = @itemSlot.count, true
		var targetItemInfo = backpack.pack.items[@targetSlot.slotNum]
		if(!count || count < 1){
			valid = false
		}else if(!targetItemInfo){
			backpack.pack.items[@targetSlot.slotNum] = {
				type = itemInfo.type,
				count = count,
			}
		}else if(targetItemInfo.type == itemInfo.type){
			targetItemInfo.count += count
		}else{
			valid = false
		}
		if(valid){
			var sumPrice = ITEMS_INFO[@itemSlot.type].price * count
			Player.bullets >= sumPrice || throw "error price to buy"
			
			Player.bullets = Player.bullets - sumPrice
			backpack.updateBullets()
			backpack.updateItems()
		}
		shop.resetTargetSlot()
	
		@clearShopItemCount()
		
		@itemSelected.pos = @itemSlot.size/2
		@itemSelected.parent = @itemSlot
		@itemSelected.color = Color.WHITE
	},
	
	startHudDragndrop = function(){
	},
	
	findHudTargetSlot = function(actor){
		return (actor is ItemSlot && actor.owner is Backpack) || actor is HudSlot
	},
	
	handleHudDragndrop = function(){
		@itemSelected.pos = @itemSlot.size/2
		@itemSelected.parent = @itemSlot
		@itemSelected.color = Color.WHITE
	},
	
	breakHudDragndrop = function(){
	},
	
	cleanup = function(){
		stage.removeEventListener(@startEventId)
		stage.removeEventListener(@moveEventId)
		stage.removeEventListener(@endEventId)
	},
}