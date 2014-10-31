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

DoorTile = extends FrontTile {
	STATE_CLOSED = 0,
	STATE_OPENING = 1,
	STATE_OPENED = 2,
	STATE_CLOSING = 3,

	__construct = function(tile, type, itemType){
		super(tile, type, itemType)
		@parent = @tile.game.mapLayers[MAP_LAYER_TILE_FRONT_DOOR]

		@door = Sprite().attrs {
			resAnim = @resAnim, // res.get(resName),
			// pivot = vec2(0, 0),
			pos = vec2(0, 0),
			// size = @size,
			// scale = @scale,
			parent = this,
		}
		@resAnim = null
		@size = Tile.SIZE
		
		@door.scale = @size / @door.size
		@door.size = @size

		var type = @tile.frontType
		@handle = Sprite().attrs {
			resAnim = res.get(TILES_INFO[type].handle),
			pivot = vec2(0.51, 0.51),
			pos = @size / 2,
			priority = 2,
			parent = @door,
		}
		@handleShadow = Sprite().attrs {
			resAnim = res.get(TILES_INFO[type].handleShadow),
			pivot = @handle.pivot,
			pos = @handle.pos + vec2(@width * 0.02, @height * 0.05),
			opacity = 0.5,
			priority = 1,
			parent = @door,
		}
		
		@openY = -@height
		@handleAction = null
		@timeoutHandle = null
		@state = @STATE_CLOSED
		@sound = null
	},
	
	createBackTile = function(){
		var back = BackTile(@tile)
		back === @tile.back || throw "error init tile.back"
		@tile.back.visible = false
	},
	
	__get@openState = function(){
		return @door.y / @openY
	},
	
	__get@isPassable = function(){
		return @state != @STATE_CLOSED
	},
	
	cleanup = function(){
		@sound.fadeOut(0.5)
		super()
	},
	
	pause = function(){
		super()
		@sound.fadeOut(0.5)
		// @sound.pause()
	},
	
	resume = function(){
		// @sound.resume()
		super()
	},
	
	open = function(){
		if(@state == @STATE_OPENING || @state == @STATE_OPENED){
			return
		}
		@state = @STATE_OPENING
		@removeTimeout(@timeoutHandle); @timeoutHandle = null
		@handleAction.target.removeAction(@handleAction)
		
		@sound.stop()
		@sound = splayer.play {
			sound = "door",
		}
		
		var destAngle = 360*2.3
		@handleAction = @handle.addTweenAction {
			duration = (1 - @handle.angle / destAngle) * 1.0,
			angle = destAngle,
			ease = Ease.CUBIC_IN_OUT,
			tickCallback = function(){
				@handleShadow.angle = @handle.angle
			},
			doneCallback = function(){
				@tile.back.visible = true
				@tile.game.updateMapTiles(@tile.tileX-1, @tile.tileY-1, @tile.tileX+1, @tile.tileY+1, true)
				@handleAction = @door.addTweenAction {
					duration = 1.0, // (1 - @openState) * 1.0,
					y = @openY,
					ease = Ease.CUBIC_IN_OUT,
					doneCallback = function(){
						@handleAction = null
						@state = @STATE_OPENED
						@sound.fadeOut(0.5); @sound = null
						@timeoutHandle = @addTimeout(1.0, function(){
							@close()
						})
					},
				}
			},
		}
	},
	
	close = function(){
		if(@state == @STATE_CLOSING || @state == @STATE_CLOSED){
			return
		}
		@state = @STATE_CLOSING
		@removeTimeout(@timeoutHandle); @timeoutHandle = null
		@handleAction.target.removeAction(@handleAction)
		
		@sound.stop()
		@sound = splayer.play {
			sound = "door-02",
		}
		
		@timeoutHandle = @addTimeout(0.4, function(){
			@timeoutHandle = null
			var ent = @tile.game.getTileEnt(@tile.tileX, @tile.tileY)
			if(ent){
				@open()
			}
		})
		
		@handleAction = @door.addTweenAction {
			duration = 1.0,
			y = 0,
			ease = Ease.CUBIC_IN_OUT,
			doneCallback = function(){
				@state = @STATE_CLOSED
				@tile.back.visible = false
				@tile.game.updateMapTiles(@tile.tileX-1, @tile.tileY-1, @tile.tileX+1, @tile.tileY+1, true)
				@handleAction = @handle.addTweenAction {
					duration = 1.0,
					angle = 0,
					ease = Ease.CUBIC_IN_OUT,
					tickCallback = function(){
						@handleShadow.angle = @handle.angle
					},
					doneCallback = function(){
						@sound.fadeOut(1.5); @sound = null
						@handleAction = null
					},
				}
			},
		}
	},
	
	pickByEnt = function(ent){
		@open()
		return true
	},
}