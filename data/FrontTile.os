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

FrontTile = extends BaseLayerTile {
	__construct = function(tile){
		super(tile)
		
		var type = @tile.frontType
		var layer = TILES_INFO[type].item ? MAP_LAYER_TILE_ITEM : MAP_LAYER_TILE_FRONT
		@parent = @tile.game.mapLayers[layer]
		@tile.front && throw "tile.front is already set"
		@tile.front = this
		// @tile.back.visible = false
		
		var resName = @tile.game.getTileResName("tile", type, @tile.tileX, @tile.tileY, TILES_INFO[type].variants)
		@resAnim = res.get(resName)
		@scale = Tile.SIZE / @size
		@size = Tile.SIZE
		@touchEnabled = type != TILE_TYPE_EMPTY
		
		if(TILES_INFO[type].glowing){
			var glowing = Sprite().attrs {
				resAnim = res.get(resName.."-glow"),
				pivot = @pivot, // vec2(0, 0),
				pos = @pos,
				scale = @scale,
				size = @size,
				// priority = @PRIORITY_FRONT,
				parent = @tile.game.mapLayers[MAP_LAYER_TILE_GLOWING],
			}
			// @glowing.scale = @size / @glowing.size
			@addLinkTile(glowing)
		}
		
		@createItemTile()
		@createBackTile()
		
		@fallingAction = null
		@fallingTimeout = null
		@fallingInProgress = null		
	},
	
	cleanup = function(){
		@tile.front === this || throw "error to clear tile.front"
		@tile.front = null
		super()
	},
	
	__get@openState = function(){
		return 0.0
	},
	
	__get@isPassable = function(){
		return TILES_INFO[@tile.frontType].passable
	},
	
	__get@isTransparent = function(){
		return TILES_INFO[@tile.frontType].transparent
	},
	
	__get@touchSprite = function(){
		return @isTransparent ? @tile.back.touchSprite : this
	},
	
	createItemTile = function(){
		if(@tile.itemType != ITEM_TYPE_EMPTY){
			if(@isPassable){
				var itemResName = @tile.game.getSlotItemResName(@tile.itemType)
				@item = Sprite().attrs {
					resAnim = res.get(itemResName),
					pivot = vec2(0.5, 0.5),
					pos = @pos + @size/2,
					// priority = @PRIORITY_ITEM,
					parent = @tile.game.mapLayers[MAP_LAYER_TILE_GLOWING],
				}
			}else{
				var itemResName = @tile.game.getTileItemResName(@tile.itemType, @tile.tileX, @tile.tileY)
				@item = Sprite().attrs {
					resAnim = res.get(itemResName),
					pivot = vec2(0.5, 0.5),
					pos = @pos + @size/2,
					// priority = @PRIORITY_ITEM,
					parent = @tile.game.mapLayers[MAP_LAYER_TILE_FRONT_ITEM],
				}
				if(ITEMS_INFO[@tile.itemType].glowing){
					@itemGlowing = Sprite().attrs {
						resAnim = res.get(itemResName.."-glow"),
						pivot = vec2(0.5, 0.5),
						pos = @pos + @size/2,
						// priority = @PRIORITY_FRONT,
						parent = @tile.game.mapLayers[MAP_LAYER_TILE_GLOWING],
					}
					@addLinkTile(@itemGlowing)
					// @itemGlowing.scale = @size / @glowing.size
				}else{
					// @item.pos = @pos + @size/2
					@item.parent = @tile.game.mapLayers[MAP_LAYER_TILE_GLOWING],
				}
			}
			@addLinkTile(@item)
		}
	},
	
	createBackTile = function(){
		var isTransparent = @isTransparent
		// var canFalling = @tile.frontType == TILE_TYPE_ROCK
		if(isTransparent){ // || canFalling){
			@needBackTile()
			// back.visible = isTransparent
		}
	},
	
	needBackTile = function(){
		if(!@tile.back){
			var back = BackTile(@tile)
			back === @tile.back || throw "error init tile.back"
		}
	},
	
	canFalling = function(){
		var tx, ty = @tile.tileX, @tile.tileY
		if(@tile.frontType == TILE_TYPE_ROCK){
			for(var dx = -1; dx < 2; dx++){
				for(var dy = -1; dy < 2; dy++){
					dx == 0 && dy == 0 && continue
					var type = @tile.game.getFrontType(tx + dx, ty + dy)
					if(type == TILE_TYPE_DOOR_01){
						return false
					}
					var type = @tile.game.getBackType(tx + dx, ty + dy)
					if(type == TILE_TYPE_TRADE_STOCK){
						return false
					}
				}
			}
			var type = @tile.game.getFrontType(tx, ty + 1)
			return type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDER
		}
	},
	
	checkStartFalling = function(){
		!@fallingInProgress && @canFalling() && @startFalling()
	},
	
	falling = function(continues){
		@fallingInProgress && return;
		// continues || @game.shakeCamera(0.1, 1)
		var game = @tile.game
		var tx, ty = @tile.tileX, @tile.tileY
		var type = @tile.frontType // game.getFrontType(tx, ty)
		var itemType = @tile.itemType // game.getItemType(tx, ty)
		
		// game.setFrontType(tx, ty, TILE_TYPE_EMPTY)
		// game.updateMapTiles(tx-1, ty-1, tx+1, ty+1, true)
		// game.setFrontType(tx, ty, type)
		
		@needBackTile()
		@tile.back.visible = true
		
		@fallingInProgress = @addTweenAction {
			duration = continues ? 0.2 : 0.5,
			y = @y + TILE_SIZE,
			ease = continues ? Ease.LINEAR : Ease.CUBIC_IN,
			doneCallback = function(){
				// continues || game.playRockfallSound()
				// @detach()
				// @fallingInProgress = null
				// @parent = @game.layers[LAYER_TILES]
				game.setFrontType(tx, ty, TILE_TYPE_EMPTY)
				game.setItemType(tx, ty, ITEM_TYPE_EMPTY)
				game.deleteTile(tx, ty)
				game.deleteCrack(tx, ty)
				ty = ty + 1
				game.setFrontType(tx, ty, type)
				game.setItemType(tx, ty, itemType)
				game.deleteTile(tx, ty)
				game.deleteCrack(tx, ty)
				game.updateMapTiles(tx-1, ty-2, tx+1, ty+1, true)
				
				var ent = game.getTileEnt(tx, ty)
				ent.die()
				
				var tile = game.getTile(tx, ty)
				if(tile.front.canFalling()){
					tile.front.falling(true)
				}else{
					game.shakeCamera(0.04)
					game.playRockfallSound()
				}
			},
		}
		game.updateMapTiles(tx-1, ty-1, tx+1, ty+1, true)
	},
	
	__get@isFalling = function(){
		return @fallingInProgress || @fallingTimeout
	},
	
	startFalling = function(){
		@fallingInProgress && return;
		if(!@fallingTimeout){
			@tile.game.shakeCamera(0.02)
			
			// @savePriority = @priority
			// @priority = TILE_PRIORITY_FALLING
			// @saveFrontParent = @parent
			@parent = @tile.game.mapLayers[MAP_LAYER_TILE_FRONT_FALLING]
			
			// @saveBackVisible = @tile.back.visible
			@needBackTile()
			@tile.back.visible = true
			
			@fallingTimeout = @addTimeout(3.0, function(){
				@fallingAction = null
				@fallingTimeout = null
				// @priority = @savePriority
				@pos = @tile.pos
				// @parent = @saveFrontParent
				// @tile.back.visible = @saveBackVisible
				@falling()
			})
			var tx, ty = @tile.tileX, @tile.tileY
			@tile.game.updateMapTiles(tx-1, ty-1, tx+1, ty+1, true)
		}
		@fallingAction && return;
		@fallingAction = @replaceTweenAction {
			name = "falling",
			duration = 0.05,
			pos = @tile.pos + vec2(randSign(), randSign()) * (TILE_SIZE * 0.05),
			doneCallback = function(){
				@fallingAction = null
				@startFalling()
			}
		}
	},
}