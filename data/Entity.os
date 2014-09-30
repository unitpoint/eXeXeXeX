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
		pushing = false,
		// moveActive = false,
		moveDir = vec2(0, 0), // vec2(randSign(), randSign()),
		prevMoveDir = vec2(0, 0),
		// moveStarted = false,
		// moveFinishedCallback = null,
		
		fly = false
	},
	
	__construct = function(game, type){
		super()
		@game = game
		@type = type
		@name = game.getResName("ent", type)
		@fly = ENTITIES_INFO[type].fly
		@sprite = Sprite().attrs {
			resAnim = res.get(@name),
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
		
		var dx = @tileX - @prevTileX
		if((dx == 1 || dx == -1) && @prevTileY == @tileY){
			var ent = @getTileEnt(@prevTileX, @prevTileY - 1)
			if(ent && !ent.moving){
				ent.moveDir = vec2(dx, 0)
				ent.update()
			}
		}
	},
	
	setTilePos = function(tx, ty){
		@setTile(tx, ty)
		@pos = @game.tileToCenterPos(tx, ty)
	},
	
	getAutoFrontType = function(tx, ty){
		return @game.getAutoFrontType(tx, ty)
	},
	
	getTileEnt = function(tx, ty){
		var ent = @game.getTileEnt(tx, ty)
		return ent === this ? null : ent
	},
	
	isTileEmptyToMove = function(tx, ty){
		var type = @getAutoFrontType(tx, ty)
		return (type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDERS) 
			&& !@getTileEnt(tx, ty)
	},
	
	isTileEmptyToFall = function(tx, ty){
		var type = @getAutoFrontType(tx, ty)
		return type == TILE_TYPE_EMPTY
			&& !@getTileEnt(tx, ty)
	},
	
	pushByEnt = function(ent, dx, dy){
		if(!@moving && !@pushing){
			var tileX, tileY = @tileX, @tileY
			@moveDir, @pushing = vec2(dx, dy), true
			@update()
			@pushing = false
			return tileX != @tileX || tileY != @tileY
		}
	},
	
	onMoveFinished = function(){
		
	},
	
	checkMoveDir = function(){
	
	},
	
	update = function(){
		var pos = @pos
		var tileX, tileY = @game.posToTile(pos)
		var curTileX, curTileY = tileX, tileY
		var pickTileX, pickTileY
		var sensorSizeX, sensorSizeY = 0.4, 0.4
		// var isDestTile = tileX == @tileX && tileY == @tileY
		if(@moveDir.x != 0 || @moveDir.y != 0) do{
			@checkMoveDir()
			var dx, dy = @moveDir.x, @moveDir.y
			if(math.abs(dx) > sensorSizeX){
				dx = dx < 0 ? -1 : 1
			}else{
				dx = 0
			}
			if(math.abs(dy) > sensorSizeY){
				dy = dy < 0 ? -1 : 1
			}else{
				dy = 0
			}
			dx == 0 && dy == 0 && break
			
			@prevMoveDir = @moveDir
			@moveDir = vec2(0, 0)
			@moving = true
			// print "cur pos tile: ${tileX}, ${tileY}"
			// print "   dest tile: ${@tileX}, ${@tileY}"
			// print "  pos: ${pos}, move dir: ${dx}, ${dy}"
			/* if(!@fly && !@moveAnimatedY && moveDirY > sensorSizeY
				// && @isTileEmptyToMove(tileX, tileY + 1)
				&& @getAutoFrontType(tileX, tileY + 1) == TILE_TYPE_LADDERS
				&& !@getTileEnt(tileX, tileY + 1))
			{
				// print "move down ladders: ${tileX}, ${tileY + 1}"
				@setTile(tileX, tileY + 1)
				break
			} */
			do{ if(!@moveAnimatedX && dx != 0){
				var sideJump = function(){
					var empty = @isTileEmptyToMove(tileX + dx, tileY - 1)
					if(!empty){
						var ent = @getTileEnt(tileX + dx, tileY - 1)
						// print "begin try push ent to jump: ${ent.name}, ent.moving: ${ent.moving}, my pos: ${tileX}x${tileY}"
						if(ent.pushByEnt(this, dx, 0) || ent.pushByEnt(this, -dx, 0)){
							empty = @isTileEmptyToMove(tileX + dx, tileY - 1)
						}
						// print "end try push ent, ok: ${empty}"
					}
					if(empty){
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
						return true
					}
				}.bind(this)
				
				if(@isTileEmptyToMove(tileX + dx, tileY)){
					// print "side move: ${tileX + dx}, ${tileY}"
					if(dy < 0 
						// && @isTileEmptyToMove(tileX, tileY) // == TILE_TYPE_LADDERS
						&& (@getAutoFrontType(tileX, tileY) == TILE_TYPE_LADDERS
							|| @getAutoFrontType(tileX, tileY + 1) != TILE_TYPE_EMPTY)
						&& (@isTileEmptyToMove(tileX, tileY - 1) || @getTileEnt(tileX, tileY - 1))
						&& sideJump())
					{
						return
					}
					@setTile(tileX += dx, tileY)
					break
				}
				var ent = @getTileEnt(tileX + dx, tileY)
				if(ent.pushByEnt(this, dx, 0) && @isTileEmptyToMove(tileX + dx, tileY)){
					// print "push & side move: ${tileX + dx}, ${tileY}"
					@setTile(tileX += dx, tileY)
					break
				}
				if(dy < 1 && (@fly 
						|| @getAutoFrontType(tileX, tileY) == TILE_TYPE_LADDERS
						|| @getAutoFrontType(tileX, tileY + 1) != TILE_TYPE_EMPTY 
						|| @getTileEnt(tileX, tileY + 1))
					&& (@isTileEmptyToMove(tileX, tileY - 1) || @getTileEnt(tileX, tileY - 1))
					&& sideJump())
				{
					return
				}
				if(@game.player === this)
				switch(@game.inventary.mode){
				case "pick":
					pickTileX = tileX + dx
					// @game.pickTile(tileX + dx, tileY)
					break
					
				default:
				case "move":
					break
					
				case "ladders":
					break
					
				case "attack":
					break
				}
			} }while(false)
			if(!@moveAnimatedY && dy != 0){
				if(tileX != curTileX && dy < 0 && !@fly && (this is Monster)){
					// print "tileX is changed, skip jump"
					break
				}
				var empty = @isTileEmptyToMove(tileX, tileY + dy)
				if(!empty){
					var ent = @getTileEnt(tileX, tileY + dy)
					if(ent.pushByEnt(this, 0, dy)){
						empty = @isTileEmptyToMove(tileX, tileY + dy)
					}
				}
				if(empty){
					if(!@fly && dy < 0){
						var upTileType = @getAutoFrontType(tileX, tileY - 1)
						var curTileType = @getAutoFrontType(tileX, tileY)
						var downTileType = @getAutoFrontType(tileX, tileY + 1)
						// print "tiles ${tileX}x${tileY}, up-down: ${upTileType}, ${curTileType}, ${downTileType}"
						if(curTileType == TILE_TYPE_EMPTY && upTileType == TILE_TYPE_EMPTY 
							&& (downTileType != TILE_TYPE_EMPTY || @getTileEnt(tileX, tileY + 1)))
						{
							// print "jump move: ${tileX}, ${tileY - 1}"
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
						if(curTileType == TILE_TYPE_EMPTY && upTileType != TILE_TYPE_LADDERS){
							// print "#1 curTileType == TILE_TYPE_EMPTY && upTileType != TILE_TYPE_LADDERS"
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
					pickTileY = tileY + dy
					// @game.pickTile(tileX, tileY + dy)
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
		if(!@fly && !@moveAnimatedY && tileY == curTileY 
			&& @isTileEmptyToFall(tileX, tileY + 1)
			&& @getAutoFrontType(tileX, tileY) != TILE_TYPE_LADDERS)
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
				var moveOffs = speed * @game.dt
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
					if(pickTileX || pickTileY){
						@game.pickTile(pickTileX || tileX, pickTileY || tileY)
					}
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