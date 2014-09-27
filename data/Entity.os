Entity = extends Actor {
	__object = {
		tileX = -1,
		tileY = -1,
		prevTileX = -1,
		prevTileY = -1,
		
		breathingSpeed = 1.0,
		attackSpeed = 1.0,
		moveSpeed = 1.0,
		
		centerActionHandle = null,
		attackCallback = null,
		// moveTween = null,
		
		isPlayer = false,
		
		moveAnimatedX = false,
		moveAnimatedY = false,
		moving = false,
		// moveActive = false,
		moveDir = vec2(randSign(), randSign()),
		prevMoveDir = vec2(0, 0),
		// moveStarted = false,
		// moveFinishedCallback = null,
	},
	
	__construct = function(game, name){
		super()
		@game = game
		@name = name
		@sprite = Sprite().attrs {
			resAnim = res.get(name),
			pivot = vec2(0.5, 0.5),
			scale = 0.9,
			parent = this,
		}
		@pivot = vec2(0.5, 0.5)
		@size = @sprite.size 
		@sprite.pos = @idealPos = @size/2
		@touchChildrenEnabled = false
		@breathing()
	},
	
	centerSprite = function(){
		@sprite.replaceTweenAction {
			name = "centerSprite",
			duration = 0.1,
			pos = @idealPos,
			angle = 0,
		}
	},
	
	setTile = function(tx, ty){
		if(@tileX != tx){
			@replaceTweenAction {
				name = "scaleX",
				duration = 0.15 * @moveSpeed,
				scaleX = @tileX > tx ? 1 : -1,
				ease = Ease.CUBIC_IN_OUT,
			}
		}
		@game.setEntTile(this, tx, ty)
	},
	
	setTilePos = function(tx, ty){
		@setTile(tx, ty)
		@pos = @game.tileToCenterPos(tx, ty)
	},
	
	getTileType = function(tx, ty){
		return @game.getTileType(tx, ty)
	},
	
	getTileEnt = function(tx, ty){
		var ent = @game.getTileEnt(tx, ty)
		return ent === this ? null : ent
	},
	
	isTileEmptyToMove = function(tx, ty){
		var type = @getTileType(tx, ty)
		return (type == TILE_EMPTY || type == TILE_LADDERS) 
			&& !@getTileEnt(tx, ty)
	},
	
	isTileEmptyToFall = function(tx, ty){
		var type = @getTileType(tx, ty)
		return type == TILE_EMPTY
			&& !@getTileEnt(tx, ty)
	},
	
	pushByEnt = function(ev, ent, dx, dy){
		if(!@moving){
			@moveDir = vec2(dx, dy)
			@update(ev)
			return true
		}
	},
	
	onMoveFinished = function(){
		
	},
	
	update = function(ev){
		var pos = @pos
		var tileX, tileY = @game.posToTile(pos)
		var curTileX, curTileY = tileX, tileY
		var sensorSizeX, sensorSizeY = 0.4, 0.4
		// var isDestTile = tileX == @tileX && tileY == @tileY
		var moveDirX, moveDirY = @moveDir.x, @moveDir.y
		if(moveDirX != 0 || moveDirY != 0) do{
			@prevMoveDir = @moveDir
			@moveDir = null
			@moving = true
			// print "cur pos tile: ${tileX}, ${tileY}"
			// print "   dest tile: ${@tileX}, ${@tileY}"
			// print "  pos: ${pos}, move dir: ${moveDirX}, ${moveDirY}"
			if(!@moveAnimatedY && moveDirY > sensorSizeY
				// && @isTileEmptyToMove(tileX, tileY + 1)
				&& @getTileType(tileX, tileY + 1) == TILE_LADDERS
				&& !@getTileEnt(tileX, tileY + 1))
			{
				// print "move down ladders: ${tileX}, ${tileY + 1}"
				@setTile(tileX, tileY + 1)
				break
			}
			if(!@moveAnimatedX && math.abs(moveDirX) > sensorSizeX){
				var dx = moveDirX < 0 ? -1 : 1
				/* if(tileX + dx != @prevTileX){ // same side move
					if(tileX != @tileX){
						break
					}
				} */
				if(@isTileEmptyToMove(tileX + dx, tileY)){
					// print "side move: ${tileX + dx}, ${tileY}"
					@setTile(tileX + dx, tileY)
					break
				}
				var ent = @getTileEnt(tileX + dx, tileY)
				if(ent.pushByEnt(ev, this, dx, 0) && @isTileEmptyToMove(tileX + dx, tileY)){
					@setTile(tileX + dx, tileY)
					break
				}
				if((@getTileType(tileX, tileY + 1) != TILE_EMPTY || @getTileEnt(tileX, tileY + 1))
					&& @isTileEmptyToMove(tileX, tileY - 1)
					&& @isTileEmptyToMove(tileX + dx, tileY - 1))
				{	// side jump
					// print "side jump move: ${tileX + dx}, ${tileY - 1}"
					@setTile(tileX + dx, tileY - 1)
					var time = 0.3 * @moveSpeed
					var pos = @game.tileToCenterPos(tileX + dx, tileY - 1)
					
					@moveAnimatedX = @addTweenAction {
						// name = "moving",
						duration = time * 1.7,
						x = pos.x,
						// ease = Ease.QUAD_IN,
						doneCallback = function(){ @moveAnimatedX = false }.bind(this),
					}
					@moveAnimatedY = @addTweenAction {
						// name = "jumping",
						duration = time * 1.5,
						y = pos.y,
						ease = Ease.BACK_IN_OUT,
						doneCallback = function(){ @moveAnimatedY = false }.bind(this),
					}
					return
				}
				if(@game.player === this)
				switch(@game.inventary.mode){
				case "pick":
					@game.pickTile(tileX + dx, tileY)
					break
					
				default:
				case "move":
					break
					
				case "ladders":
					break
					
				case "attack":
					break
				}
			}
			if(!@moveAnimatedY && math.abs(moveDirY) > sensorSizeY){
				var dy = moveDirY < 0 ? -1 : 1
				var empty = @isTileEmptyToMove(tileX, tileY + dy)
				if(!empty){
					var ent = @getTileEnt(tileX, tileY + dy)
					if(ent.pushByEnt(ev, this, 0, dy)){
						empty = @isTileEmptyToMove(tileX, tileY + dy)
					}
				}
				if(empty){
					if(dy < 0){
						var upTileType = @getTileType(tileX, tileY - 1)
						var curTileType = @getTileType(tileX, tileY)
						var downTileType = @getTileType(tileX, tileY + 1)
						// print "tiles ${tileX}x${tileY}, up-down: ${upTileType}, ${curTileType}, ${downTileType}"
						if(curTileType == TILE_EMPTY && upTileType == TILE_EMPTY 
							&& (downTileType != TILE_EMPTY || @getTileEnt(tileX, tileY + 1)))
						{
							@setTile(tileX, tileY - 1)
							var time = 0.3 * @moveSpeed
							var pos = @game.tileToCenterPos(tileX, tileY - 1)
							@moveAnimatedY = @addTweenAction {
								// name = "jumping",
								duration = time * 1.5,
								y = pos.y,
								ease = Ease.BACK_IN_OUT,
								doneCallback = function(){ @moveAnimatedY = false }.bind(this),
							}
							return
						}
						if(curTileType == TILE_EMPTY && upTileType != TILE_LADDERS){
							// print "#1 curTileType == TILE_EMPTY && upTileType != TILE_LADDERS"
							break
						}
						// print "#3 no"
					}
					// print "vert move: ${tileX}, ${tileY + dy}"
					@setTile(tileX, tileY + dy)
					break
				}
				if(@game.player === this)
				switch(@game.inventary.mode){
				case "pick":
					@game.pickTile(tileX, tileY + dy)
					break
					
				default:
				case "move":
					break
					
				case "ladders":
					break
					
				case "attack":
					break
				}
			}
		}while(false)
		
		var tileX, tileY = @tileX, @tileY
		if(!@moveAnimatedY && tileY == curTileY 
			&& @isTileEmptyToFall(tileX, tileY + 1)
			&& @getTileType(tileX, tileY) != TILE_LADDERS)
		{
			// print "falling move: ${tileX}, ${tileY + 1}"
			@setTile(tileX, ++tileY)
			@moving = true
		}
		
		if(@moving){
			var dest = @game.tileToCenterPos(tileX, tileY)
			var offs = dest - pos
			var len = #offs
			if(len > 0){
				var speed = TILE_SIZE / (0.3 * @moveSpeed)
				var moveOffs = speed * ev.dt
				if(moveOffs >= len){
					// prevent float number accuracy
					if(!@moveAnimatedX){
						@x = dest.x
					}
					if(!@moveAnimatedY){
						@y = dest.y
					}
				}else{
					var offsScale = moveOffs / len
					if(!@moveAnimatedX){
						@x += offs.x * offsScale
					}
					if(!@moveAnimatedY){
						@y += offs.y * offsScale
					}
				}
			}
			if(!@moveAnimatedX && !@moveAnimatedY){
				if(@x == dest.x && @y == dest.y){
					@moving = false
					@onMoveFinished()
				}
			}
		}
	},
	
	stopBreathing = function(){
		@centerSprite()
		@sprite.replaceTweenAction {
			name = "breathing",
			duration = 0.1,
			scale = 0.9,
		}
	},
	
	breathing = function(speed){
		@centerSprite()
		speed && @breathingSpeed = speed
		var anim = function(){
			var action = SequenceAction(
				TweenAction {
					duration = 1.1 * math.random(0.9, 1.1) / @breathingSpeed,
					scale = 0.94,
					ease = Ease.CIRC_IN_OUT,
				},
				TweenAction {
					duration = 0.9 * math.random(0.9, 1.1) / @breathingSpeed,
					scale = 0.9,
					ease = Ease.CIRC_IN_OUT,
				},
			)
			action.name = "breathing"
			action.doneCallback = anim
			@sprite.replaceAction(action)
		}.bind(this)
		anim()
	},
	
	attack = function(side, speed, callback){
		@stopBreathing()
		// @centerSprite()
		// @sprite.pos = @idealPos
		if(functionOf(side)){
			side, speed, callback = null, null, side
		}else if(functionOf(speed)){
			speed, callback = null, speed
		}
		speed && @attackSpeed = speed
		var pos2 = @idealPos + vec2(128 * 0.2 * (side || 1), 0)
		var anim = function(){
			@sprite.replaceTweenAction {
				name = "attack",
				duration = 0.15 * math.random(0.9, 1.1) / @breathingSpeed,
				pos = pos2,
				angle = math.random(-10, 10),
				ease = Ease.QUINT_IN,
				doneCallback = function(){
					// print "attack mid, attackCallback: ${@attackCallback}"
					@sprite.replaceTweenAction {
						name = "attack",
						duration = 0.8 * math.random(0.9, 1.1) / @breathingSpeed,
						pos = @idealPos,
						angle = 0,
						ease = Ease.CIRC_IN_OUT,
						doneCallback = callback // anim
					}
					@attackCallback()
				}.bind(this)
			}
		}.bind(this)
		anim()
	},
}