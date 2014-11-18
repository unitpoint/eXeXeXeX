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

TilePlatformItem = extends TileItem {
	__object = {
		moving = false,
		updateHandle = null,
	},
	
	createPhysBody = function(){
		var elem = ELEMENTS_LIST[@type]
		var size = @size
		var halfSize = size / 2
		var bodyDef = PhysBodyDef()
		bodyDef.type = PHYS_BODY_KINEMATIC
		bodyDef.pos = @pos + halfSize
		// bodyDef.linearDamping = 0.99
		// bodyDef.angularDamping = 0.99
		// bodyDef.isSleepingAllowed = false
		@body = @game.physWorld.createBody(bodyDef)
		@body.item = this
		
		// elem.platformPhysSizeScale && halfSize = halfSize * elem.platformPhysSizeScale
		var fixtureDef = PhysFixtureDef()
		// fixtureDef.type = PHYS_SHAPE_POLYGON
		// fixtureDef.setPolygonAsBox(halfSize, center, 0)
		// fixtureDef.setPolygonAsBounds(vec2(0, 0), @size)
		var a = size * (elem.platformPhysA || 0) - halfSize
		var b = size * (elem.platformPhysB || 1) - halfSize
		fixtureDef.setPolygonAsBounds(a, b)
		fixtureDef.categoryBits = PHYS_CAT_BIT_SOLID | PHYS_CAT_BIT_ITEM | PHYS_CAT_BIT_PLATFORM 
			| (elem.platformCastShadow !== false && !elem.platformPhysCellSize ? PHYS_CAT_BIT_CAST_SHADOW : 0)
		// fixtureDef.friction = 0.99
		@body.createFixture(fixtureDef)
		
		if(elem.platformPhysCellSize && elem.platformCastShadow !== false){
			size = b - a
			var cellCount = elem.platformPhysCellCount
			var cellSize = size * elem.platformPhysCellSize
			if(elem.platformPhysCellTiled){
				var emptySizeX = (size.x - cellSize.x * cellCount) / cellCount
				a.x = a.x + emptySizeX/2
			}else{
				var emptySizeX = (size.x - cellSize.x * cellCount) / (cellCount - 1)
			}
			for(var i = 0; i < cellCount; i++){
				var ca = a + vec2(i * (cellSize.x + emptySizeX), 0)
				var cb = ca + cellSize
				var fixtureDef = PhysFixtureDef()
				fixtureDef.setPolygonAsBounds(ca, cb)
				fixtureDef.categoryBits = PHYS_CAT_BIT_CAST_SHADOW
				@body.createFixture(fixtureDef)
			}
		}
	},
	
	updateLinkPos = function(){
		if(!@moving){
			@body.pos = @pos + @size / 2
		}
	},
	
	isLiftShaft = function(tx, ty, sx, sy){
		var ex, ey = tx+sx, ty+sy
		for(var x = tx; x < ex; x++){
			for(var y = ty; y < ey; y++){
				var type = @game.getFrontType(x, y)
				type == ELEM_TYPE_EMPTY || return false
				
				var type = @game.getBackType(x, y)
				ELEMENTS_LIST[type].isLiftShaft || return false
			}
		}
		return true
	},
	
	canStop = function(tx, ty, sx, sy){
		if(@game.getFrontType(tx-1, ty) != ELEM_TYPE_EMPTY
			&& @game.getFrontType(tx-1, ty-1) == ELEM_TYPE_EMPTY)
		{
			// @game.addDebugMessage("can stop: left")
			return true
		}
		if(@game.getFrontType(tx+sx, ty) != ELEM_TYPE_EMPTY
			&& @game.getFrontType(tx+sx, ty-1) == ELEM_TYPE_EMPTY)
		{
			// @game.addDebugMessage("can stop: right")
			return true
		}
	},
	
	movePlatform = function(dir){
		dir = dir > 0 ? 1 : -1
		if(@moving && (@body.linearVelocity.y < 0) == (dir < 0)){
			return
		}
		
		var elem = ELEMENTS_LIST[@type]
		if(@isLiftShaft(@tileX, @tileY + dir, elem.cols, elem.rows)){
			@moving = true
			var startTileY = @tileY
			@body.linearVelocity = vec2(0, dir * TILE_SIZE / 0.3)
			@removeUpdate(@updateHandle)
			@updateHandle = @addUpdate(function(){
				@pos = @body.pos - @size / 2
				var ty = @game.singlePosToTile(@y)
				ty == @tileY && return;
				
				if((startTileY != @tileY && @canStop(@tileX, @tileY + (dir < 0 ? 0 : 1), elem.cols, elem.rows))
					|| !@isLiftShaft(@tileX, ty + (dir < 0 ? 0 : 1), elem.cols, elem.rows))
				{
					@removeUpdate(@updateHandle)
					@updateHandle = null
					@moving = false
					@body.linearVelocity = vec2(0, 0)
					@pos = @game.tileToPos(@tileX, @tileY + (dir < 0 ? 0 : 1))
				}else{
					@tileY = ty
				}
			})
			return true
		}else{
			// @game.addDebugMessage("it's not lift shaft: ${@tileX}, ${@tileY + dir}, ${elem.cols}, ${elem.rows}")
		}
	},
}
