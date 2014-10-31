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

StandFlame = extends Actor {
	__construct = function(game, tile){
		super()
		@game = game
		@parent = @game.mapLayers[MAP_LAYER_TILE_ITEM]
		
		@childrenRelative = false
		@pivot = vec2(0.5, 1)
		@pos = tile.pos + vec2(tile.width/2, tile.height)
		
		@stand = Sprite().attrs {
			resAnim = res.get("fire-stand"),
			pivot = vec2(0.5, 1),
			priority = 1,
			parent = this,
		}
		
		@flame = AnimSprite("flame-%02d", 14).attrs {
			pivot = vec2(0.5, 1),
			x = 0,
			y = 19 - @stand.height,
			priority = 0,
			parent = this,
		}
		
		@touchEnabled = false
		@touchChildrenEnabled = false
		
		var lightTileRadius = 2
		var lightTileRadiusScale = 1.5 // dependence on light name
		var lightRadius = lightTileRadius * lightTileRadiusScale * TILE_SIZE
		// var lightColor = Color(1.0, 0.95, 0.7)
		var lightColor = Color(1, 1, 1)
		@light = Light().attrs {
			name = "light-03",
			shadowColor = Color(0.2, 0.2, 0.2),
			color = lightColor,
			radius = lightRadius,
			// pos = @pos + @size / 2,
		}
		@game.addLight(@light)
		// print "StandFlame.new: ${@parent.tileX}x${@parent.tileY}"
		
		var handle = @addUpdate(0.05, function(){
			var r = lightColor.r * math.random(0.9, 1.1)
			var g = lightColor.g * math.random(0.9, 1.1)
			var b = lightColor.b * math.random(0.9, 1.1)
			@light.color = Color(r, g, b)
			// @light.pos = @parent.pos + vec2(math.random(0.4, 0.6), math.random(0.4, 0.6)) * TILE_SIZE
			@light.pos = tile.pos + vec2(math.random(0.4, 0.6), math.random(0.4, 0.6)) * TILE_SIZE
			// print "update light color: ${@light.color}, pos: ${@light.pos}"
		})
	},
	
	cleanup = function(){
		// print "StandFlame.cleanup: ${@parent.tileX}x${@parent.tileY}"
		@game.removeLight(@light)
	},
}