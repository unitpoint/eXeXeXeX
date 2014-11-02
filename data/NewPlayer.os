VEC2_UP = vec2(0, -1)

// SNAP_SIZE = TILE_SIZE / 2
// SNAP_SHIFT = 0

SNAP_SIZE = TILE_SIZE
SNAP_SHIFT = 0.5

NewPlayer = extends Player {
	__construct = function(game, name){
		super(game, name)
		
		@waddleStarted = false
		@body = null
		@wheelRadius = TILE_SIZE / 2 * 0.96
		@maxSpeed = TILE_SIZE * 4
		
		@destPosX = @snapPos(@x, 0)
		@destPosY = null
		
		@addTimeout(0.1, function(){
			var bodyDef = PhysBodyDef()
			bodyDef.type = PHYS_BODY_DYNAMIC
			bodyDef.pos = @pos
			bodyDef.linearDamping = 0.99
			bodyDef.angularDamping = 0.99
			bodyDef.isSleepingAllowed = false
			@body = @game.physWorld.createBody(bodyDef)
			
			var fixtureDef = PhysFixtureDef()
			fixtureDef.type = PHYS_SHAPE_CIRCLE
			fixtureDef.circleRadius = @wheelRadius
			fixtureDef.categoryBits = PHYS_CAT_BIT_PLAYER
			fixtureDef.maskBits = PHYS_CAT_BIT_GROUND | PHYS_CAT_BIT_LADDER | PHYS_CAT_BIT_PIT
			fixtureDef.friction = 0.2
			fixtureDef.restitution = 0.0
			fixtureDef.density = 1
			@body.createFixture(fixtureDef)
			
			@body.testContactCallback = @testContact.bind(this)
			@body.beginContactCallback = @registerContact.bind(this)
			@body.endContactCallback = @unregisterContact.bind(this)
			
			@destPosX = @snapPos(@x, 0)
		})
		
		@jumpTime = 0
		@contacts = {}
		@groundContact = null
		@ladderContact = null
		@pitContact = null
	},
	
	testContact = function(contact, i){
		var storedContact = @contacts[contact.id]
		if(storedContact){
			var dot = contact.normal.dot(VEC2_UP)
			var angle = math.deg(math.acos(dot))
			storedContact.merge {
				// fixture = contact.getFixture(i),
				normal = contact.normal,
				point = contact.point,
				angle = angle,
				dot = dot,
			}
		}
		// @game.addDebugMessage("[test ${contact.id}] p:(${contact.point.x|0},${contact.point.y|0}), n:(${math.round(contact.normal.x,1)},${math.round(contact.normal.y,1)})")
		return PHYS_CONTACT_STEP_ENABLED
	},
	
	registerContact = function(contact, i){
		var dot = contact.normal.dot(VEC2_UP)
		var angle = math.deg(math.acos(dot))
		@contacts[contact.id] = {
			id = contact.id,
			fixture = contact.getFixture(i),
			normal = contact.normal,
			point = contact.point,
			angle = angle,
			dot = dot,
			time = @game.time,
		}
		// @game.addDebugMessage("[+ ${contact.id}] fix_id: ${contact.getFixture(i).id}, cat: ${contact.getFixture(i).categoryBits}, angle: ${angle|0}, p: ${contact.point.x|0}, ${contact.point.y|0}")
		// @game.addDebugMessage("[+ ${contact.id}] angle: ${angle}, contacts: ${#@contacts}")
	},
	
	unregisterContact = function(contact, i){
		delete @contacts[contact.id]
		// @game.addDebugMessage("[- ${contact.id}] fix_id: ${contact.getFixture(i).id}, cat: ${contact.getFixture(i).categoryBits}")
		// @game.addDebugMessage("[- ${contact.id}] contacts: ${#@contacts}")
	},
	
	cleanup = function(){
		// @game.physWorld.destroyBody(@body)
		@body.destroy()
		@body = null
		
		super()
	},
	
	updateContacts = function(){
		// var wasLadderContact = @ladderContact
		@groundContact = @ladderContact = @pitContact = null
		var bestGroundAngle = 45
		for(var _, contact in @contacts){
			if(bestGroundAngle > contact.angle && @game.time - contact.time > 0.05){
				bestGroundAngle = contact.angle
				@groundContact = contact
			}
			if(contact.fixture.categoryBits & PHYS_CAT_BIT_LADDER != 0){
				@ladderContact = contact
			}
			if(contact.fixture.categoryBits & PHYS_CAT_BIT_PIT != 0){
				@pitContact = contact
			}
		}
		/* if(wasLadderContact && !@ladderContact){
			@game.addDebugMessage("release ladder contact")
		}else if(!wasLadderContact && @ladderContact){
			@game.addDebugMessage("found ladder contact")
		} */
	},
	
	snapPos = function(x, dx){
		return (math.floor(x / SNAP_SIZE) + (dx || 0) + SNAP_SHIFT) * SNAP_SIZE
	},
	
	applyDestX = function(){
		var linearVelocity = @body.linearVelocity
		var dx = clamp((@destPosX - @x) / SNAP_SIZE * 1.0, -1, 1)
		var forceScale = clamp(1 - math.abs(linearVelocity.x) / @maxSpeed, -1, 1)
		var groundContact = @groundContact
		forceScale = forceScale * math.max(0.25, groundContact.dot || 0)
		if(math.abs(dx) < 0.05){
			linearVelocity.x = dx * @maxSpeed * forceScale
			@body.linearVelocity = linearVelocity
		}else{
			@body.applyForceToCenter(vec2(dx * 50 * forceScale / @game.physWorld.toPhysScale, 0))
		}
		if(groundContact || @body.gravityScale > 0){
			@body.angularVelocity = 360 * @maxSpeed / (2*math.PI*@wheelRadius) * dx * 1.5
		}else{
			@body.angularVelocity = 0
		}
	},
	
	applyDestY = function(){
		var linearVelocity = @body.linearVelocity
		var dy = clamp((@destPosY - @y) / SNAP_SIZE * 1.0, -1, 1)
		var forceScale = clamp(1 - math.abs(linearVelocity.y) / @maxSpeed, -1, 1)
		if(math.abs(dy) < 0.05){
			linearVelocity.y = dy * @maxSpeed * forceScale
			@body.linearVelocity = linearVelocity
		}else{
			@body.applyForceToCenter(vec2(0, dy * 50 * forceScale / @game.physWorld.toPhysScale))
		}
	},
	
	updateDestPos = function(){
		var groundContact, ignorePosX = @groundContact, false
		if(!groundContact){
			/* var tileX, tileY = @game.posToTile(@pos)
			var type = @game.getFrontType(tileX, tileY)
			if(type != TILE_TYPE_LADDER){
				ignorePosX = true
			} */
			if(!@ladderContact){
				ignorePosX = true
			}
			// var x = @body.linearVelocity.x / SNAP_SIZE
			@destPosX = @snapPos(@x) // , x > 0.1 ? 1 : x < -0.1 ? -1 : 0)
		}
		if(!ignorePosX && @destPosX){
			@applyDestX()
		}
		if(@destPosY){
			@applyDestY()
		}
	},
	
	update = function(){
		if(!@body || @isDead){
			return
		}
		@updateContacts()
		/* var tileX, tileY = @game.posToTile(@pos)
		var type = @game.getFrontType(tileX, tileY)
		var onLadder = type == TILE_TYPE_LADDER */
		if(@ladderContact){
			@body.gravityScale = 0
			@destPosY = @snapPos(@y)
		}else{
			@body.gravityScale = 1
			@destPosY = null
		}
		if(@game.moveJoystick.active){
			// @destPosY = null
			@moveDir = @game.moveJoystick.dir
			
			var groundContact = @groundContact
			if(math.abs(@moveDir.x) > 0.25){
				var side = @moveDir.x > 0 ? 1 : -1
				@destPosX = @snapPos(@x, side)
				@setSideFlip(-side)
				if(!@ladderContact){
					if(@pitContact){
						@body.gravityScale = 0.1
					}
					/* 
					// TODO: add sensor for this area?
					var tileX, tileY = @game.posToTile(@pos)
					var type = @game.getFrontType(tileX, tileY+1)
					if(type == TILE_TYPE_EMPTY || type == TILE_TYPE_LADDER){
						var type = @game.getFrontType(tileX - side, tileY+1)
						if(type != TILE_TYPE_EMPTY && type != TILE_TYPE_LADDER){
							var type = @game.getFrontType(tileX + side, tileY+1)
							if(type != TILE_TYPE_EMPTY && type != TILE_TYPE_LADDER){
								@body.gravityScale = 0.1
								// @game.addDebugMessage("fix gravityScale")
							}
						}
					} */
				}
				@applyDestX()
			}
			if(@moveDir.y < -0.5 && groundContact && @game.time - @jumpTime > 0.1){
				@destPosY = null
				@jumpTime = @game.time
				var jumpForce = 430 / @game.physWorld.toPhysScale
				var tileX, tileY = @game.posToTile(@pos)
				var type = @game.getFrontType(tileX, tileY-1)
				if(type != TILE_TYPE_LADDER){
					var type = @game.getFrontType(tileX + (side || 0), tileY-2)
					if(type != TILE_TYPE_EMPTY && type != TILE_TYPE_LADDER){
						jumpForce *= 0.7
					}else{
						var type = @game.getFrontType(tileX, tileY-1)
						if(type != TILE_TYPE_EMPTY && type != TILE_TYPE_LADDER){
							jumpForce *= 0.7
						}
					}
				}else{
					jumpForce *= 0.7
				}
				@body.applyForceToCenter(vec2(0, -jumpForce))
				groundContact.fixture.body.applyForce(vec2(0, jumpForce), groundContact.point)
			}else if(@ladderContact && math.abs(@moveDir.y) > 0.25){ // || @moveDir.y > 0){
				// @destPosX = @snapPos(@x + (side || 0))
				@destPosY = @snapPos(@y, @moveDir.y > 0 ? 1 : -1)
				@applyDestY()
				if(@moveDir.x == 0){
					@destPosX = @snapPos(@x)
					@applyDestX()
				}
			}else if(@destPosY){
				@applyDestY()
			}
		}else{
			@updateDestPos()
		}
		// super()
	},
	
	startWaddle = function(){
		if(@waddleEnabled){
			var side = @body.linearVelocity.x > 0 ? 1 : -1
			@replaceAction("moveAngle", RepeatForeverAction(SequenceAction(
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
			)))
		}
	},
	
	stopWaddle = function(){
		@replaceTweenAction {
			name = "moveAngle",
			duration = 0.1 * @moveSpeed,
			angle = 0,
		}
	},
	
	updatePos = function(){
		if(@body){
			@pos = @body.pos - vec2(0, TILE_SIZE / 2 * 0.04)
			var run = #@body.linearVelocity > TILE_SIZE
			if(run){
				if(!@waddleStarted){
					@waddleStarted = true
					@startWaddle()
				}
			}else{
				if(@waddleStarted){
					@waddleStarted = false
					@stopWaddle()
				}
			}
		}
		
		@light.pos = @pos + vec2(math.random(-0.02, 0.02) * TILE_SIZE, math.random(-0.02, 0.02) * TILE_SIZE)
		@light.radius = @lightTileRadius * @lightTileRadiusScale * TILE_SIZE * math.random(0.98, 1.02)
		
		@game.playerTargetTile.pos = @game.tileToCenterPos(@tileX, @tileY)	
	},
	
}