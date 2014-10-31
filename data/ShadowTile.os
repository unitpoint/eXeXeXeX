ShadowTile = extends BaseLayerTile {
	__construct = function(tile){
		super(tile)
		@parent = @tile.game.mapLayers[MAP_LAYER_TILE_SHADOW]
		@tile.shadow && throw "tile.shadow is already set"
		@tile.shadow = this
		@updateShadow()
	},
	
	cleanup = function(){
		@tile.shadow === this || throw "error to clear tile.shadow"
		@tile.shadow = null
		super()
	},
	
	isPassableAt = function(x, y){
		var type = @tile.game.getFrontType(x, y)
		if(type == TILE_TYPE_EMPTY){
			return true
		}
		var tile = @tile.game.getTile(x, y)
		return tile.front.isPassable || tile.front.isFalling/******************************************************************************
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


	},
	
	resetShadow = function(){
		@removeChildren()
	},
	
	updateShadow = function(recreate){
		recreate && @removeChildren()
		@firstChild && return;
		
		var x, y = @tile.tileX, @tile.tileY
		@isPassableAt(x, y) || return;
		
		var top = @isPassableAt(x, y-1)
		var bottom = @isPassableAt(x, y+1)
		var left = @isPassableAt(x-1, y)
		var right = @isPassableAt(x+1, y)
		var leftTop = @isPassableAt(x-1, y-1)
		var rightTop = @isPassableAt(x+1, y-1)
		var leftBottom = @isPassableAt(x-1, y+1)
		var rightBottom = @isPassableAt(x+1, y+1)
		
		var opacity = 0.7
		if(!top){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-left"),
				angle = 90,
				// pos = vec2(0, 0),
				pivot = vec2(0, 1),
				opacity = opacity,
				parent = this
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
				parent = this
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
				parent = this
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
				parent = this
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
				parent = this,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!left && !top){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				// pivot = vec2(0, 0),
				opacity = opacity,
				parent = this,
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
				parent = this,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!right && !top){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				pivot = vec2(0, 0),
				angle = 90,
				x = TILE_SIZE,
				opacity = opacity,
				parent = this,
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
				parent = this,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}else if(!left && !bottom){
			var fade = Sprite().attrs {
				resAnim = res.get("tile-fade-inner-left-top"),
				// pivot = vec2(0, 0),
				y = TILE_SIZE,
				angle = -90,
				opacity = opacity,
				parent = this,
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
				parent = this,
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
				parent = this,
			}
			fade.scale = vec2(TILE_FADE_SIZE, TILE_FADE_SIZE) / fade.size
		}
	},
}