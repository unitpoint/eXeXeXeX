Monster = extends Entity {
	__construct = function(game, name){
		super(game, name)
		@aiQueryTime = 0
		@aiNextTime = null
		@nextMoveDir = null
		@saveTileX, @saveTileY = -1, -1
		@patrolArea = null
	},
	
	createPatrolAreaIfNecessary = function(){
		if(@patrolArea){
			var tx, ty = @tileX, @tileY
			if(tx < @patrolArea.start.x || tx > @patrolArea.end.x
				|| ty < @patrolArea.start.y || ty > @patrolArea.end.y)
			{
				// print "delete patrol area:${@classname}#${@__id}, tile: ${@tileX}, ${@tileY}: ${@patrolArea}"
				@patrolArea = null
			}else{
				return
			}
		}
		@getTileType(@tileX, @tileY + 1) == TILE_EMPTY && return;
		
		@patrolArea = {
			start = vec2(@tileX, @tileY - 2),
			end = vec2(@tileX, @tileY + 2),
		}
		var maxAreaWidth = 4
		var sideLocked = [false, false]
		for(var i = 1;; i++){
			@patrolArea.end.x - @patrolArea.start.x + 1 >= maxAreaWidth && break
			sideLocked[0] && sideLocked[1] && break
			for(var side = 0; side < 2; side++){
				if(!sideLocked[side]){
					var tx, ty = @tileX + (side == 0 ? -i : i), @tileY
					if(@getTileType(tx, ty) == TILE_EMPTY
						&& @getTileType(tx, ty + 1) == TILE_EMPTY
						&& @getTileType(tx, ty + 2) == TILE_EMPTY)
					{
						sideLocked[side] = true
					}else if(@getTileType(tx, ty) != TILE_EMPTY
						&& @getTileType(tx, ty - 1) != TILE_EMPTY)
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
		// print "create patrol area:${@classname}#${@__id}, tile: ${@tileX}, ${@tileY}: ${@patrolArea}"
	},
	
	checkMoveDirByPatrolArea = function(){
		if(@patrolArea){
			var tilePos = vec2(@tileX, @tileY)
			for(var i = 0; i < 2; i++){
				var nx = tilePos[i] + @moveDir[i]
				if( (nx < @patrolArea.start[i] && tilePos[i] >= @patrolArea.start[i])
					|| (nx > @patrolArea.end[i] && tilePos[i] <= @patrolArea.end[i])
					)
				{
					@moveDir[i] = -@moveDir[i]
					// print "${@classname}#${@__id}, tile: ${@tileX}, ${@tileY}, change move dir[${i}]: ${@moveDir[i]}"
				}
			}
		}
	},
	
	onMoveFinished = function(){
		// print "onMoveFinished:${@classname}#${@__id}, tile: ${@tileX}, ${@tileY}"
		if(math.random() < 0.8 && (@saveTileX != @tileX || @saveTileY != @tileY)){
			@moveDir = @prevMoveDir
			@checkMoveDirByPatrolArea()
		}else if(math.random() < 0.8){
			if(math.random() < 0.8){
				var px, py = @game.player.tileX, @game.player.tileY
				var dx = px > @tileX ? 1 : px < @tileX ? -1 : -@prevMoveDir.x
				var dy = py > @tileY ? 1 : py < @tileY ? -1 : 0
				/* if(dy != 0 && @getTileType(@tileX, @tileY + dy) == TILE_EMPTY){
					dx = 0
				} */
				@nextMoveDir = vec2(dx, dy)
			}else{
				@nextMoveDir = vec2(-@prevMoveDir.x, 0)
			}
		}
		@aiNextTime = @game.time + math.random(2, 5)
		@saveTileX, @saveTileY = @tileX, @tileY
	},
	
	pushByEnt = function(ev, ent, dx, dy){
		if(ent is Monster && @patrolArea){
			var tx, ty = @tileX + dx, @tileY + dy
			if(tx < @patrolArea.start.x || tx > @patrolArea.end.x){
				return
			}
		}
		return super(ev, ent, dx, dy)
	},
	
	update = function(ev){
		super(ev)
		if(!@moving && @aiNextTime <= @game.time){
			@createPatrolAreaIfNecessary()
			if(@game.time - @aiQueryTime < 3){
				// @aiNextTime = @game.time + math.random(0.3, 1)
				// print "ai update:${@classname}#${@__id}, tile: ${@tileX}, ${@tileY}"
				@moveDir = @nextMoveDir || vec2(randSign(), math.random() - 0.4).normalize()
				@nextMoveDir = null
				@checkMoveDirByPatrolArea()
			}
			@aiNextTime = null
		}
	},
	
	queryAI = function(){
		@aiQueryTime = @game.time
		@aiNextTime || @aiNextTime = @game.time
	},
}