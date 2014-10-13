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

Tile = extends BaseTile {
	PRIORITY_BACK 	= 10,
	PRIORITY_FRONT 	= 20,
	PRIORITY_SHADOW = 30,
	PRIORITY_FRONT_FALLING = 35,
	PRIORITY_FRONT_DOOR = 35,
	PRIORITY_ITEM 	= 40,
	PRIORITY_TOUCH 	= 50,
	
	__construct = function(game, x, y){
		super(game, x, y)
		
		@frontType = @game.getFrontType(x, y)
		var frontType = @frontType == TILE_TYPE_BLOCK ? TILE_TYPE_ROCK : @frontType
		
		@backType = @game.getBackType(x, y)
		var backType = @backType == TILE_TYPE_BLOCK ? TILE_TYPE_ROCK : @backType
		
		var frontResName = @game.getTileResName("tile", frontType, x, y, TILES_INFO[frontType].variants)
		@front = Sprite().attrs {
			resAnim = res.get(frontResName),
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			priority = @PRIORITY_FRONT,
			parent = this
		}
		@front.scale = @size / @front.size
		
		var backResName = @game.getTileResName("tile", backType, x, y, TILES_INFO[backType].variants)
		@back = Sprite().attrs {
			resAnim = res.get(backResName),
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			priority = @PRIORITY_BACK,
			parent = this
		}
		if(backType < 16){
			// @back.color = Color(0.2, 0.2, 0.2)
			@back.color = Color(0.5, 0.5, 0.5)
		}else{
			// @back.color = Color(0.7, 0.7, 0.7)
		}
		@back.scale = @size / @back.size
		
		if(@frontType == TILE_TYPE_EMPTY){
			@front.visible = false
		}else if(@frontType != TILE_TYPE_LADDERS){
			@back.visible = false
		}
		
		@glowing = null
		if(TILES_INFO[frontType].glowing){
			@glowing = Sprite().attrs {
				resAnim = res.get(frontResName.."-glow"),
				pivot = vec2(0, 0),
				pos = @pos,
				// priority = @PRIORITY_FRONT,
				parent = @game.glowingTiles,
			}
			@glowing.scale = @size / @glowing.size
		}
		
		@item = null
		@itemGlowing = null
		@itemType = @game.getItemType(x, y)
		if(@itemType != ITEM_TYPE_EMPTY){
			if(@frontType != TILE_TYPE_EMPTY){
				var itemResName = @game.getTileItemResName(@itemType, x, y)
				@item = Sprite().attrs {
					resAnim = res.get(itemResName),
					pivot = vec2(0.5, 0.5),
					pos = @size/2,
					priority = @PRIORITY_ITEM,
					parent = this,
				}
				if(ITEMS_INFO[@itemType].glowing){
					@itemGlowing = Sprite().attrs {
						resAnim = res.get(itemResName.."-glow"),
						pivot = vec2(0, 0),
						pos = @pos,
						// priority = @PRIORITY_FRONT,
						parent = @game.glowingTiles,
					}
					// @itemGlowing.scale = @size / @glowing.size
				}else{
					@item.pos = @pos + @size/2
					@item.parent = @game.glowingTiles
				}
			}else{
				var itemResName = @game.getSlotItemResName(@itemType)
				@item = Sprite().attrs {
					resAnim = res.get(itemResName),
					pivot = vec2(0.5, 0.5),
					pos = @pos + @size/2,
					// priority = @PRIORITY_ITEM,
					parent = @game.glowingTiles,
				}
			}
			// @item.scale = @size / math.max(@item.width, @item.height)
		}
		
		@shadow = Actor().attrs {
			size = @size,
			priority = @PRIORITY_SHADOW,
			parent = this,
		}
		
		@touchSprite = null
		@touchSpriteSaveColor = null
		
		@fallingAction = null
		@fallingTimeout = null
		@fallingInProgress = null
	},
	
	cleanup = function(){
		@glowing.detach()
		@itemGlowing.detach()
		@front.detach()
		@back.detach()
		@item.detach()
		@shadow.detach()
		@detach()
	},
	
	touch = function(){
		if(!@touchSprite){
			if(@front.visible){
				@touchSprite = @front
			}else{
				@touchSprite = @back
			}
			@touchSpriteSaveColor = @touchSprite.color
		}
		@touchSprite.replaceAction("touch", TweenAction{
			duration = 0.5,
			color = Color(1, 0.4, 0.4),
			ease = Ease.PING_PONG,
			doneCallback = function(){
				@touchSprite.color = @touchSpriteSaveColor
				@touchSprite = @touchSpriteSaveColor = null
			},
		})
		/*
		if(!@touchSprite){
			@touchSprite = Box9Sprite().attrs {
				resAnim = res.get("white"),
				size = @size,
				color = Color(1, 0.4, 0.4),
				opacity = 0,
				priority = @PRIORITY_TOUCH,
				parent = this,
			}
		}
		@touchSprite.replaceAction("bump", TweenAction{
			duration = 0.5,
			opacity = 0.5,
			ease = Ease.PING_PONG,
			detachTarget = true,
			doneCallback = function(){
				@touchSprite = null
			},
		})
		*/
	},
	
	explodeItem = function(){
		@itemType != ITEM_TYPE_EMPTY || return;
		var sound = splayer.play {
			sound = "bomb-countdown",
			looping = true,
		}
		var wait = ITEMS_INFO[@itemType].explodeWait || 1
		@addTimeout(wait, function(){
			sound.stop()
			@itemType != ITEM_TYPE_EMPTY || return;
			var radius = ITEMS_INFO[@itemType].explodeRadius || 1
			var damage = ITEMS_INFO[@itemType].damage || 1
			var tx, ty = @tileX, @tileY
			@game.setItemType(tx, ty, ITEM_TYPE_EMPTY)
			var areaRadius = math.ceil(radius)
			var ax, ay = tx - areaRadius, ty - areaRadius
			var bx, by = tx + areaRadius, ty + areaRadius
			for(var y = ay; y <= by; y++){
				for(var x = ax; x <= bx; x++){
					var r = math.sqrt((x-tx)**2 + (y-ty)**2)
					if(r <= radius){
						@game.setFrontType(x, y, TILE_TYPE_EMPTY)
						@game.removeTile(x, y, true)
						@game.getTileEnt(x, y).damage(damage)
					}
				}
			}
			@game.updateTiledmapViewport(ax-1, ay-1, bx+1, by+1)
		})
	},
	
	canFalling = function(){
		var tx, ty = @tileX, @tileY
		if(@frontType == TILE_TYPE_ROCK){
			for(var dx = -1; dx < 2; dx++){
				for(var dy = -1; dy < 2; dy++){
					dx == 0 && dy == 0 && continue
					var type = @game.getFrontType(tx + dx, ty + dy)
					if(type == TILE_TYPE_DOOR_01){
						return false
					}
					var type = @game.getBackType(tx + dx, ty + dy)
					if(type == TILE_TYPE_TRADE_STOCK){
						return false
					}
				}
			}
			var type = @game.getFrontType(tx, ty + 1)
			return type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS
		}
	},
	
	checkStartFalling = function(){
		!@fallingInProgress && @canFalling() && @startFalling()
	},
	
	falling = function(continues){
		@fallingInProgress && return;
		var tx, ty = @tileX, @tileY
		var frontType = @game.getFrontType(tx, ty)
		var itemType = @game.getItemType(tx, ty)
		@game.setFrontType(tx, ty, TILE_TYPE_EMPTY)
		@game.setItemType(tx, ty, ITEM_TYPE_EMPTY)
		@game.removeTile(tx, ty)
		@game.updateTiledmapViewport(tx-1, ty-1, tx+1, ty+1)
		@parent = @game.layers[LAYER_FALLING_TILES]
		@shadow.removeChildren()
		@fallingInProgress = @addTweenAction {
			duration = continues ? 0.2 : 0.5,
			y = @y + TILE_SIZE,
			ease = continues ? Ease.LINEAR : Ease.CUBIC_IN,
			doneCallback = function(){
				@detach()
				// @fallingInProgress = null
				// @parent = @game.layers[LAYER_TILES]
				ty = ty + 1
				@game.setFrontType(tx, ty, frontType)
				@game.setItemType(tx, ty, itemType)
				@game.removeTile(tx, ty, true)
				@game.updateTiledmapViewport(tx-1, ty-1, tx+1, ty+1)
				
				var ent = @game.getTileEnt(tx, ty)
				ent.die()
				
				var tile = @game.getTile(tx, ty)
				tile.canFalling() && tile.falling(true)
				
				/* frontType = @game.getFrontType(tx, ty + 1)
				if((frontType == TILE_TYPE_EMPTY || frontType == TILE_TYPE_LADDERS)
					&& @game.getBackType(tx, ty + 1) != TILE_TYPE_TRADE_STOCK)
				{
					var tile = @game.getTile(tx, ty)
					tile.falling(true)
				} */
			},
		}
	},
	
	startFalling = function(){
		@fallingInProgress && return;
		if(!@fallingTimeout){
			@fallingTimeout = @addTimeout(3.0, function(){
				@front.replaceTweenAction {
					name = "falling",
					duration = 0.05,
					pos = vec2(0, 0),
				}
				@fallingAction = null
				@fallingTimeout = null
				@priority = @savePriority
				@back.visible = @saveBackVisible
				@falling()
			})
		}
		@fallingAction && return;
		@fallingAction = @front.replaceTweenAction {
			name = "falling",
			duration = 0.05,
			pos = vec2(randSign(), randSign()) * (TILE_SIZE * 0.05),
			doneCallback = function(){
				@fallingAction = null
				@startFalling()
			}
		}
		@savePriority = @priority
		@priority = TILE_PRIORITY_FALLING
		
		@saveBackVisible = @back.visible
		@back.visible = true
	},
	
	__get@isEmpty = function(){
		return @frontType == TILE_TYPE_EMPTY || @frontType == TILE_TYPE_LADDERS
	},
	
	getIsEmpty = function(x, y){
		var type = @game.getFrontType(x, y)
		if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS){
			return true
		}
		var tile = @game.getTile(x, y)
		return tile.isEmpty
	},
	
	updateShadow = function(){
		@shadow.removeChildren()
		
		var x, y = @tileX, @tileY
		@getIsEmpty(x, y) || return;
		
		var top = @getIsEmpty(x, y-1)
		var bottom = @getIsEmpty(x, y+1)
		var left = @getIsEmpty(x-1, y)
		var right = @getIsEmpty(x+1, y)
		var leftTop = @getIsEmpty(x-1, y-1)
		var rightTop = @getIsEmpty(x+1, y-1)
		var leftBottom = @getIsEmpty(x-1, y+1)
		var rightBottom = @getIsEmpty(x+1, y+1)
		
		var opacity = 0.7
		if(!top){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-left"),
				angle = 90,
				// pos = vec2(0, 0),
				pivot = vec2(0, 1),
				opacity = opacity,
				parent = @shadow
			}
			var x, size = 0, TILE_SIZE
			if(!left){
				x = TILE_FADE_SIZE
				size = size - TILE_FADE_SIZE
			}
			if(!right){
				size = size - TILE_FADE_SIZE
			}
			fade.x = x
			fade.scale = vec2(TILE_FADE_SIZE, size) / fade.size
		}
		if(!bottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-left"),
				angle = -90,
				// pos = vec2(0, 0),
				y = TILE_SIZE,
				pivot = vec2(0, 0),
				opacity = opacity,
				parent = @shadow
			}
			var x, size = 0, TILE_SIZE
			if(!left){
				x = TILE_FADE_SIZE
				size = size - TILE_FADE_SIZE
			}
			if(!right){
				size = size - TILE_FADE_SIZE
			}
			fade.x = x
			fade.scale = vec2(TILE_FADE_SIZE, size) / fade.size
		}
		if(!left){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-left"),
				angle = 0,
				// pos = vec2(0, 0),
				pivot = vec2(0, 0),
				opacity = opacity,
				parent = @shadow
			}
			var y, size = 0, TILE_SIZE
			if(!top){
				y = TILE_FADE_SIZE
				size = size - TILE_FADE_SIZE
			}
			if(!bottom){
				size = size - TILE_FADE_SIZE
			}
			fade.y = y
			fade.scale = vec2(TILE_FADE_SIZE, size) / fade.size
		}
		if(!right){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-left"),
				angle = 180,
				// pos = vec2(0, 0),
				x = TILE_SIZE,
				pivot = vec2(0, 1),
				opacity = opacity,
				parent = @shadow
			}
			var y, size = 0, TILE_SIZE
			if(!top){
				y = TILE_FADE_SIZE
				size = size - TILE_FADE_SIZE
			}
			if(!bottom){
				size = size - TILE_FADE_SIZE
			}
			fade.y = y
			fade.scale = vec2(TILE_FADE_SIZE, size) / fade.size
		}
		if(left && top && !leftTop){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-outer-left-top"),
				// pivot = vec2(0, 0),
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!left && !top){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				// pivot = vec2(0, 0),
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}
		if(right && top && !rightTop){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-outer-left-top"),
				pivot = vec2(0, 0),
				angle = 90,
				x = TILE_SIZE,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!right && !top){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				pivot = vec2(0, 0),
				angle = 90,
				x = TILE_SIZE,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}
		if(left && bottom && !leftBottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-outer-left-top"),
				// pivot = vec2(0, 0),
				y = TILE_SIZE,
				angle = -90,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!left && !bottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				// pivot = vec2(0, 0),
				y = TILE_SIZE,
				angle = -90,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}
		if(right && bottom && !rightBottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-outer-left-top"),
				// pivot = vec2(0, 0),
				x = TILE_SIZE,
				y = TILE_SIZE,
				angle = 180,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!right && !bottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				// pivot = vec2(0, 0),
				x = TILE_SIZE,
				y = TILE_SIZE,
				angle = 180,
				opacity = opacity,
				parent = @shadow,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}
	},
}