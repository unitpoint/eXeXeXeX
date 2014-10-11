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

Monster = extends Entity {
	__construct = function(game, name){
		super(game, name)
		@parent = game.layers[LAYER_MONSTERS]
		@aiQueryTime = 0
		@aiNextTime = null
		@nextMoveDir = null
		@saveTileX, @saveTileY = -1, -1
		@patrolArea = null
		@moveTimeoutHandle = null
		@warnOnMove = true
	},
	
	createPatrolAreaIfNecessary = function(){
		if(@fly){
			@patrolArea || @{
				@patrolArea = {
					start = vec2(@tileX - 1, @tileY - 0),
					end = vec2(@tileX + 1, @tileY + 1),
				}
				// print "create fly patrol area ${@classname}#${@__id}:${@name}, tile: ${@tileX}, ${@tileY}: ${@patrolArea}"
			}
			return
		}
		if(@patrolArea){
			var tx, ty = @tileX, @tileY
			if(tx < @patrolArea.start.x || tx > @patrolArea.end.x
				|| ty < @patrolArea.start.y || ty > @patrolArea.end.y)
			{
				// print "delete patrol area ${@classname}#${@__id}:${@name}, tile: ${@tileX}, ${@tileY}: ${@patrolArea}"
				@patrolArea = null
			}else{
				return
			}
		}
		@game.getFrontType(@tileX, @tileY + 1) == TILE_TYPE_EMPTY && return;
		
		@patrolArea = {
			start = vec2(@tileX, @tileY - 1),
			end = vec2(@tileX, @tileY + 1),
		}
		var maxAreaWidth = 3
		var sideLocked = [false, false]
		var startFromLadders = @game.getFrontType(@tileX, @tileY) == TILE_TYPE_LADDERS
		var isTileEmpty = function(tx, ty, allowLadders){
			var type = @game.getFrontType(tx, ty)
			if(allowLadders){
				return type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS
			}
			 return type == TILE_TYPE_EMPTY
		}
		for(var i = 1;; i++){
			@patrolArea.end.x - @patrolArea.start.x + 1 >= maxAreaWidth && break
			sideLocked[0] && sideLocked[1] && break
			for(var side = 0; side < 2; side++){
				if(!sideLocked[side]){
					var tx, ty = @tileX + (side == 0 ? -i : i), @tileY
					if(isTileEmpty(tx, ty)
						&& isTileEmpty(tx, ty + 1)
						&& (startFromLadders || isTileEmpty(tx, ty + 2)))
					{
						sideLocked[side] = true
					}else if(!isTileEmpty(tx, ty, true)
						&& !isTileEmpty(tx, ty - 1, true))
					{
						sideLocked[side] = true
					}else if(side == 0){
						@patrolArea.start.x = tx
					}else{
						@patrolArea.end.x = tx
					}
				}
			}
		}
		// print "create patrol area:${@classname}#${@__id}:${@name}, tile: ${@tileX}, ${@tileY}: ${@patrolArea}"
	},
	
	// debugCheckMoveDir = true,
	checkMoveDir = function(){
		if(@patrolArea){
			// if(@debugCheckMoveDir) print "checkMoveDir: ${@classname}#${@__id}:${@name}, tile: ${@tileX}, ${@tileY}"
			// if(@debugCheckMoveDir) print "  #0 move dir: ${@moveDir}, patrolArea: ${@patrolArea}"
			
			var dx, dy = 0, 0

			if(@fly){
				@getAutoFrontType(@tileX, @tileY + 1) != TILE_TYPE_EMPTY && dy = -1
			}
			
			if(@tileX < @patrolArea.start.x) dx = 1
			else if(@tileX > @patrolArea.end.x) dx = -1
			
			if(@tileY < @patrolArea.start.y) dy = 1
			else if(@tileY > @patrolArea.end.y) dy = -1
			
			if(dx != 0 || dy != 0){
				@moveDir.x, @moveDir.y = dx, dy
				// if(@debugCheckMoveDir) print "checkMoveDir: ${@classname}#${@__id}:${@name}, tile: ${@tileX}, ${@tileY}"
				// if(@debugCheckMoveDir) print "  #1 move dir: ${@moveDir}, patrolArea: ${@patrolArea}"
				return
			}
			
			if(!@fly && @moveDir.x != 0 
				&& @getAutoFrontType(@tileX, @tileY) == TILE_TYPE_LADDERS
				&& !@getTileEnt(@tileX, @tileY + 1)
				&& @getAutoFrontType(@tileX + @moveDir.x, @tileY) == TILE_TYPE_EMPTY
				&& @getAutoFrontType(@tileX + @moveDir.x, @tileY + 1) == TILE_TYPE_EMPTY)
			{
				@moveDir.x = 0
				if(@moveDir.y == 0){
					@moveDir.y = math.random() < 0.5 ? -1 : 1
				}
				// if(@debugCheckMoveDir) print "checkMoveDir: ${@classname}#${@__id}:${@name}, tile: ${@tileX}, ${@tileY}"
				// if(@debugCheckMoveDir) print "  #2 move dir: ${@moveDir}, patrolArea: ${@patrolArea}"
			}
			for(var i, set = 0; i < 2; i++){
				var curTile = i == 0 ? @tileX : @tileY
				var t = curTile + @moveDir[i]
				if(t < @patrolArea.start[i]){
					if(curTile + 1 > @patrolArea.end[i]){
						@moveDir[i] = set = 0
					}else{
						@moveDir[i] = set = 1
					}
				}else if(t > @patrolArea.end[i]){
					if(curTile - 1 < @patrolArea.start[i]){
						@moveDir[i] = set = 0
					}else{
						@moveDir[i] = set = -1
					}
				}
			}
			if(set){
				// @moveDir.normalize()
				// if(@debugCheckMoveDir) print "checkMoveDir: ${@classname}#${@__id}:${@name}, tile: ${@tileX}, ${@tileY}"
				// if(@debugCheckMoveDir) print "  #3 move dir: ${@moveDir}, patrolArea: ${@patrolArea}"
			}
		}
	},
	
	onMoveFinished = function(){
		super()
		// print "onMoveFinished:${@classname}#${@__id}:${@name}, tile: ${@tileX}, ${@tileY}"
		if(math.random() < 0.8 && (@saveTileX != @tileX || @saveTileY != @tileY)){
			@moveDir = @prevMoveDir
			@updateMoveDir()
		}else if(math.random() < 0.8){
			if(math.random() < 0.8){
				var px, py = @game.player.tileX, @game.player.tileY
				var dx = px > @tileX ? 1 : px < @tileX ? -1 : -@prevMoveDir.x
				var dy = py > @tileY ? 1 : py < @tileY ? -1 : 0
				/* if(dy != 0 && @getAutoFrontType(@tileX, @tileY + dy) == TILE_TYPE_EMPTY){
					dx = 0
				} */
				@nextMoveDir = vec2(dx, dy)
			}else{
				@nextMoveDir = vec2(-@prevMoveDir.x, 0)
			}
		}
		@aiNextTime = @game.time + math.random(3, 4)
		@saveTileX, @saveTileY = @tileX, @tileY
	},
	
	onTileChanged = function(){
		super()
		@createPatrolAreaIfNecessary()
	},
	
	pushByEnt = function(ent, dx, dy){
		if(ent is Monster && @patrolArea){
			var tx, ty = @tileX + dx, @tileY + dy
			if(tx < @patrolArea.start.x || tx > @patrolArea.end.x){
				return
			}
			if(ty < @patrolArea.start.y || ty > @patrolArea.end.y){
				return
			}
		}
		return super(ent, dx, dy)
	},
	
	update = function(){
		super()
		if(!@moving && @aiNextTime <= @game.time && !@moveTimeoutHandle){
			@patrolArea || @createPatrolAreaIfNecessary()
			if(@game.time - @aiQueryTime < 0.5){
				// @aiNextTime = @game.time + math.random(0.3, 1)
				// print "ai update:${@classname}#${@__id}:${@name}, tile: ${@tileX}, ${@tileY}"
				var setMoveDir = function(){
					@moveDir = @nextMoveDir || vec2(randSign(), randSign())
					@nextMoveDir = null
					@moveTimeoutHandle = null
					@updateMoveDir()
				}
				if(@warnOnMove){
					var breathingSpeed = @breathingSpeed
					@startBreathing(breathingSpeed * 16)
					@moveTimeoutHandle = @addTimeout(0.35, function(){
						@startBreathing(breathingSpeed)
						@moveTimeoutHandle = @addTimeout(0.65, setMoveDir)
					})
				}else{
					@startBreathing()
					setMoveDir()
				}
			}else{
				@stopBreathing()
			}
			@aiNextTime = null
		}
	},
	
	queryAI = function(){
		@aiQueryTime = @game.time
		@aiNextTime || @aiNextTime = @game.time
	},
}