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

Entity = extends Actor {
	__object = {
		tileX = -1,
		tileY = -1,
		prevTileX = -1,
		prevTileY = -1,
		pickTileX = null,
		pickTileY = null,
		
		breathingAction = null,
		breathingSpeed = 1.0,
		attackSpeed = 1.0,
		moveSpeed = 1.0,
		
		centerActionHandle = null,
		attackCallback = null,
		// moveTween = null,
		
		isPlayer = false,
		isDead = false,
		
		moveAnimatedX = false,
		moveAnimatedY = false,
		moving = false,
		attacking = false,
		isMoveStarted = false,
		pushingByEnt = null,
		// moveActive = false,
		moveDir = vec2(0, 0), // vec2(randSign(), randSign()),
		prevMoveDir = vec2(0, 0),
		// moveStarted = false,
		// moveFinishedCallback = null,
		waddleEnabled = true,
		
		fly = false,
		attackValue = 0,
		healthValue = 0,
		damageValue = 0,
	},
	
	getState = function(){
		return {
			tileX = @tileX,
			tileY = @tileY,
		}
	},
	
	loadState = function(state){
		// @game.unsetEntTile(this)
		@game.initEntTile(this, state.tileX, state.tileY)
	},
	
	initObject = function(levelObj){
		@game.initEntTile(this, levelObj.x, levelObj.y)
	},
	
	__construct = function(game, type, group){
		super()
		@cull = true
		@game = game
		@type = type
		group || group = "ent"
		@name = game.getResName(group, type)
		if(group == "ent"){
			@fly = ENTITIES_INFO[type].fly
			@attackValue = ENTITIES_INFO[type].attack || 25
			@healthValue = ENTITIES_INFO[type].health || @attackValue
			@damageValue = 0
		}
		
		@touchChildrenEnabled = false
		@pivot = vec2(0.5, 0.5)
		@size = vec2(TILE_SIZE, TILE_SIZE)
		// @centerPos = vec2(0, 0) // @size / 2
		// @childrenRelative = false
		@centerPos = @size / 2
		
		@moveLayer = Actor().attrs {
			pivot = vec2(0.5, 0.5),
			pos = @centerPos,
			size = @size,
			childrenRelative = false,
			parent = this,
		}
		@flipLayer = Actor().attrs {
			pivot = vec2(0.5, 0.5),
			size = @size,
			childrenRelative = false,
			parent = @moveLayer,
		}
		@sprite = Sprite().attrs {
			resAnim = res.get(@name),
			pivot = vec2(0.5, 0.5),
			// pos = @centerPos,
			// childrenRelative = false,
			// scale = @idealScale = 0.9,
			parent = @flipLayer,
		}
		
		@flipX = @flipY = 1
		
		@baseScale = @size / @sprite.size
		@flipLayer.scale = @baseScale
		
		@sprite.scale = 0.9
		
		@addUpdate(@update.bind(this))
		@addUpdate(0.1, @checkFalling.bind(this))
	},
	
	/* __get@attackValue = function(){
		return @_attackValue // (ENTITIES_INFO[@type].attack || 25) * (@tileY)
	}, */
	
	__get@attackLevel = function(){
		return math.max(0, math.floor(math.log(@attackValue / 25, 2)))
	},
	
	__get@attackCurValue = function(){
		return @attackValue * math.random(0.9, 1.1)
	},
	
	queryAI = function(){
	},
	
	centerSprite = function(){
		@attacking || @moveLayer.replaceTweenAction {
			name = "move",
			duration = 0.1,
			pos = @centerPos,
			angle = 0,
		}
	},
	
	onClick = function(ev){
	
	},
	
	onTilePosChanged = function(){
	
	},
	
	setSideFlip = function(newScaleX){
		if(newScaleX != @flipX){
			@flipLayer.replaceTweenAction {
				name = "scaleX",
				duration = 0.15 * @moveSpeed,
				scaleX = (@flipX = newScaleX) * @baseScale.x,
				ease = Ease.CUBIC_IN_OUT,
			}
		}
	},
	
	setUpFlip = function(newScaleY){
		if(newScaleY != @flipY){
			@flipLayer.replaceTweenAction {
				name = "scaleY",
				duration = 0.3 * @moveSpeed,
				scaleY = (@flipY = newScaleY) * @baseScale.y,
				ease = Ease.CUBIC_IN_OUT,
			}
		}
	},
	
	setTile = function(tx, ty){
		@tileX == tx && @tileY == ty && return;
		if(@tileX != tx){
			@setSideFlip(@tileX > tx ? 1 : -1)
		}
		@game.setEntTile(this, tx, ty)
		
		var dx = @tileX - @prevTileX
		if((dx == 1 || dx == -1) && @prevTileY == @tileY){
			var ent = @getTileEnt(@prevTileX, @prevTileY - 1)
			if(ent && !ent.moving && !ent.fly){
				ent.moveDir = vec2(dx, 0)
				ent.updateMove()
			}
		}
		// @onTileChanged()
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
		if(!@moving && !@pushingByEnt){
			if(ent.isPlayer != @isPlayer 
				&& (ent is NPC == false && this is NPC == false) 
				&& (ent is EntItem == false && this is EntItem == false))
			{
				// print "push ${@classname} by ${ent.classname}"
				@addTimeout(0.05, function(){
					// print "try #1 attack ${@classname} by ${ent.classname}, ent.attacking: ${!!ent.attacking}"
					!ent.attacking && ent.attack(this, dx)
				})
				@addTimeout(0.15, function(){ 
					// print "try #2 attack ${ent.classname} by ${@classname}, @attacking: ${!!@attacking}"
					!@attacking && @attack(ent, -dx) // , speed, doneCallback)
				})
				// return
			}
			var tileX, tileY = @tileX, @tileY
			@moveDir, @pushingByEnt = vec2(dx, dy), ent
			@updateMove()
			@pushingByEnt = null
			return tileX != @tileX || tileY != @tileY
		}
	},
	
	onMoveStarted = function(){
		if(@waddleEnabled){
			var side = @prevTileX < @tileX ? 1 : -1
			var action = RepeatForeverAction(SequenceAction(
				TweenAction {
					duration = 0.15 * @moveSpeed,
					angle = -5 * side,
					// ease = Ease.CUBIC_IN_OUT,
				},
				TweenAction {
					duration = 0.15 * @moveSpeed,
					angle = 5 * side,
					// ease = Ease.CUBIC_IN_OUT,
				},
			))
			action.name = "moveAngle"
			@replaceAction(action)
		}
	},
	
	onMoveFinished = function(){
		@replaceTweenAction {
			name = "moveAngle",
			duration = 0.1 * @moveSpeed,
			angle = 0,
		}
	},
	
	onTileChanged = function(){
	
	},
	
	checkMoveDir = function(){
	
	},
	
	updateMoveDir = function(){
		var tx, ty = @tileX, @tileY
		@_updateMoveDir()
		@_checkFalling()
		if(tx != @tileX || ty != @tileY){
			@onTileChanged()
		}
	},
	
	checkFalling = function(){
		var tx, ty = @tileX, @tileY
		// @_updateMoveDir()
		@_checkFalling()
		if(tx != @tileX || ty != @tileY){
			@onTileChanged()
		}
	},

	
	_updateMoveDir = function(){
		// var pos = @pos
		var tileX, tileY = @game.posToTile(@pos)
		var curTileX, curTileY = tileX, tileY
		// var pickTileX, pickTileY
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
						@playJumpSound()
						// @onTileChanged()
						var time = 0.3 * @moveSpeed
						var pos = @game.tileToCenterPos(tileX + dx, tileY - 1)
						
						@moveAnimatedX = @addTweenAction {
							// name = "moving",
							duration = time * 1.7,
							x = pos.x,
							// ease = Ease.QUAD_IN,
							doneCallback = function(){ @moveAnimatedX = false },
						}
						@moveAnimatedY = @addTweenAction {
							// name = "jumping",
							duration = time * 1.5,
							y = pos.y,
							ease = Ease.BACK_IN_OUT,
							doneCallback = function(){ @moveAnimatedY = false },
						}
						return true
					}
				}
				
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
					@setTile(tileX + dx, tileY)
					// @onTileChanged()
					break
				}
				var ent = @getTileEnt(tileX + dx, tileY)
				if(ent.pushByEnt(this, dx, 0) && @isTileEmptyToMove(tileX + dx, tileY)){
					// print "push & side move: ${tileX + dx}, ${tileY}"
					@setTile(tileX + dx, tileY)
					// @onTileChanged()
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
				if(@game.player === this){
					@pickTileX = tileX + dx
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
							@playJumpSound()
							// @onTileChanged()
							var time = 0.3 * @moveSpeed
							var pos = @game.tileToCenterPos(tileX, tileY - 1)
							@moveAnimatedY = @addTweenAction {
								// name = "jumping",
								duration = time * 1.5,
								y = pos.y,
								ease = Ease.BACK_IN_OUT,
								doneCallback = function(){ 
									@moveAnimatedY = false
									@blockFalling(true)
								},
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
					// @onTileChanged()
					break
				}
				if(@game.player === this){
					@pickTileY = tileY + dy
				}
			}
		}while(false)
		curTileY == @tileY && @_checkFalling()
	},
	
	blockFalling = function(afterJump){
	},
	
	_checkFalling = function(){
		var tileX, tileY = @tileX, @tileY
		if((!@fly || @isDead) && !@moveAnimatedY
			&& @isTileEmptyToFall(tileX, tileY + 1)
			&& @getAutoFrontType(tileX, tileY) != TILE_TYPE_LADDERS
			&& !@blockFalling())
		{
			// print "falling move: ${tileX}, ${tileY + 1}"
			@setTile(tileX, tileY + 1)
			// @onTileChanged()
			@moving = true
		}
	},
	
	update = function(){
		if(@moving){
			if(!@isMoveStarted){
				@isMoveStarted = true
				@onMoveStarted()
			}
			var dest = @game.tileToCenterPos(@tileX, @tileY)
			var offs = dest - @pos
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
					@isMoveStarted = false
					@onMoveFinished()
					if(@pickTileX || @pickTileY){
						@game.pickTile(@pickTileX || @tileX, @pickTileY || @tileY)
						@pickTileX = @pickTileY = null
					}
				}
			}
		}
	},

	updateMove = function(){
		@updateMoveDir()
		@update()
	},
	
	playJumpSound = function(){
	},
	
	playDeathSound = function(){
	},
	
	die = function(){
		@isDead && return;
		@stopBreathing()
		@isPlayer = false
		@isDead = true
		@setUpFlip(-1)
		@sprite.addTweenAction {
			duration = 1.0,
			color = Color(0.5, 0, 0),
		}
		@sprite.addTweenAction {
			duration = 3.0,
			// angle = math.random(-100, 100), // 360 * 10,
			// scale = 0.5,
			// scaleY = -0.9,
			opacity = 0.2,
			// ease = Ease.CUBIC_IN_OUT,
			doneCallback = function(){
				// @addTimeout(1.0, function(){
					@game.unsetEntTile(this)
					@game.cleanupActor(this)
					@detach()
					if(this is Player){
						@game.playerDead()
					}
					// doneCallback()
				// })
			},
		}
		@playDeathSound()
	},
	
	stopBreathing = function(){
		if(@breathingAction){
			@centerSprite()
			@sprite.removeActionsByName("scale")
			@sprite.scale = 0.9
			/* @sprite.replaceTweenAction {
				name = "scale",
				duration = 0.1,
				scale = 0.9,
			} */
			@breathingAction = null
		}
	},
	
	startBreathing = function(speed){
		@isDead && return;
		@breathingAction && (!speed || @breathingSpeed == speed) && return;
		@centerSprite()
		speed && @breathingSpeed = speed
		this is Player && print("startBreathing#${@__id}:${@classname}:${@__name}, speed: ${@breathingSpeed}")
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
			action.name = "scale"
			action.doneCallback = anim
			@sprite.replaceAction(action)
			@breathingAction = action
		}
		anim()
	},
	
	damage = function(value, attacker){
	},
	
	attack = function(enemy, side, speed, doneCallback){
		@isDead || @attacking && return;
		enemy.damage(@attackCurValue, this)
		// @stopBreathing()
		if(functionOf(side)){
			side, speed, callback = null, null, side
		}else if(functionOf(speed)){
			speed, callback = null, speed
		}
		@setSideFlip(side < 0 ? 1 : -1)
		print "attack:${@classname}#${@__id}, side: ${side}"
		// @scaleX < 0 && side = -side
		// @centerSprite()
		// @sprite.pos = @idealPos
		speed && @attackSpeed = speed
		var destPos = @centerPos + vec2(TILE_SIZE * 0.3 * (side || 1), 0)
		@attacking = @moveLayer.replaceTweenAction {
			name = "move",
			duration = 0.02 * math.random(0.9, 1.1) / @attackSpeed,
			// scale = @idealScale,
			pos = destPos,
			angle = randItem([-15, 0, 15]), // math.random(-15, 15),
			ease = Ease.QUINT_IN,
			doneCallback = function(){
				// print "attack mid, attackCallback: ${@attackCallback}"
				@attacking = @moveLayer.replaceTweenAction {
					name = "move",
					duration = 0.2 * math.random(0.9, 1.1) / @attackSpeed,
					pos = @centerPos,
					angle = 0,
					ease = Ease.CIRC_IN_OUT,
					doneCallback = function(){
						print "attack finished for ${@classname}#${@__id}"
						@attacking = null
						// @startBreathing()
						doneCallback()
					}
				}
				var attackCallback = @attackCallback
				attackCallback() // use function's this instead of current this
			}
		}
	},
}