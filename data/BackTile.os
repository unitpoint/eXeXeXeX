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

BackTile = extends BaseLayerTile {
	__construct = function(tile, type){
		super(tile, type)
		
		@tile.back && throw "tile.back is already set"
		@tile.back = this
		
		var type = @tile.backType
		var elem = ELEMENTS_LIST[type] || throw "unknown front type: ${type}"
		elem.isTile || throw "required tile element but found: ${elem}"
		
		if(type != ELEM_TYPE_EMPTY){
			@parent = @tile.game.mapLayers[MAP_LAYER_TILE_BACK]
			
			var resName = @tile.game.getTileResName(elem, @tile.tileX, @tile.tileY) // TILES_INFO[type].variants)
			@resAnim = res.get(resName)
			@resAnimFrameNum = (@tile.tileX % elem.cols) + (@tile.tileY % elem.rows) * elem.cols
			@fixAnimRect(0.4)
			@scale = Tile.VEC2_SIZE / @size
			@size = Tile.VEC2_SIZE
			
			elem.color && @color = elem.color
			@color = @color * (elem.backColor || Color(0.6, 0.6, 0.6))
			
			if(elem.glowing){
				var glowing = Sprite().attrs {
					resAnim = res.get(resName.."-glowing"),
					resAnimFrameNum = @resAnimFrameNum,
					pivot = @pivot, // vec2(0, 0),
					pos = @pos,
					scale = @scale,
					size = @size,
					// priority = @PRIORITY_FRONT,
					parent = @tile.game.mapLayers[MAP_LAYER_TILE_GLOWING],
				}
				// glowing.fixAnimRect(0.4)
				// @glowing.scale = @size / @glowing.size
				@addLinkTile(glowing)
			}
		}
	},
	
	cleanup = function(){
		@tile.back === this || throw "error to clear tile.back"
		@tile.back = null
		super()
	},
}