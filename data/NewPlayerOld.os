VEC2_UP = vec2(0, -1)

// SNAP_SIZE = TILE_SIZE / 2
// SNAP_SHIFT = 0

SNAP_SIZE = TILE_SIZE
SNAP_SHIFT = 0.0

NewPlayer = extends Player {
	__construct = function(game, type){
		super(game, type)
		
		var elem = ELEMENTS_LIST[type]
		var size = math.min(elem.width, elem.height)
		
		@waddleStarted = false
		@body = null
		@wheelRadius = size / 2 * 0.8
		@posShift = vec2(0, -(size / 2 - @wheelRadius))
		@maxSpeed = TILE_SIZE * 8
		
		@destPosX = @snapPos(@x, 0)
		@destPosY = null
		
		@dir = Sprite().attrs {
			resAnim = res.get("dir"),
			pivot = vec2(-6, 0.5),
			// pos = @size / 2,
			visible = false,
			parent = @game.mapLayers[MAP_LAYER_PLAYER_DIR],
		}
		
		@addTimeout(0.1, function(){
			var bodyDef = PhysBodyDef()
			bodyDef.type = PHYS_BODY_DYNAMIC
			bodyDef.pos = @pos
			bodyDef.linearDamping = 0.99
			bodyDef.angularDamping = 0.99
			bodyDef.isSleepingAllowed = false
			@body = @game.physWorld.createBody(bodyDef)
			
			var fixtureDef = PhysFixtureDef()
			// fixtureDef.type = PHYS_SHAPE_CIRCLE
			fixtureDef.circleRadius = @wheelRadius
			fixtureDef.categoryBits = PHYS_CAT_BIT_PLAYER
			fixtureDef.maskBits = PHYS_CAT_BIT_SOLID | PHYS_CAT_BIT_LADDER | PHYS_CAT_BIT_PIT
			fixtureDef.friction = 0.4
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
		@sideContact = null
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
		@body.destroy()	// @body = null
		@dir.detach()
		
		super()
	},
	
	updateContacts = function(){
		// var prevLadderContact = @ladderContact
		@groundContact = @sideContact = @ladderContact = @pitContact = null
		var bestGroundAngle = 50
		for(var _, contact in @contacts){
			if(bestGroundAngle > contact.angle && @game.time - contact.time > 0.05){
				bestGroundAngle = contact.angle
				@groundContact = contact
			}else if(contact.angle > 50){
				@sideContact = contact
			}
			if(contact.fixture.categoryBits & PHYS_CAT_BIT_LADDER != 0){
				@ladderContact = contact
			}
			if(contact.fixture.categoryBits & PHYS_CAT_BIT_PIT != 0){
				@pitContact = contact
			}
		}
		/* if(prevLadderContact && !@ladderContact){
			@game.addDebugMessage("release ladder contact")
		}else if(!prevLadderContact && @ladderContact){
			@game.addDebugMessage("found ladder contact")
		} */
	},
	
	snapPos = function(x, dx){
		return (math.round(x / SNAP_SIZE + (dx || 0)) + SNAP_SHIFT) * SNAP_SIZE
	},
	
	applyDestX = function(dx){
		var linearVelocity = @body.linearVelocity
		dx || dx = clamp((@destPosX - @x) / SNAP_SIZE * 1.0, -1, 1)
		var forceScale = clamp(1 - math.abs(linearVelocity.x) / @maxSpeed, 0, 1)
		var groundContact = @groundContact
		// groundContact || forceScale = forceScale * 0.25 // math.max(0.25, groundContact.dot || 0)
		forceScale = forceScale * math.max(0.25, groundContact.dot || 0)
		if(math.abs(dx) < 0.05){
			linearVelocity.x = dx * @maxSpeed * forceScale
			// @body.linearVelocity = linearVelocity
		}else{
			// local dx = Ease.run(Ease.LINEAR, math.abs(dx)) * (dx > 0 ? 1 : -1)
			// local forceScale = forceScale < 0.5 ? Ease.run(forceScale * 2, Ease.SINE_OUT) / 2 : forceScale
			@body.applyForceToCenter(vec2(dx * (groundContact ? 100 : 50) * forceScale / @game.physWorld.toPhysScale, 0))
		}
		linearVelocity.x = math.min(linearVelocity.x, @maxSpeed)
		@body.linearVelocity = linearVelocity
		
		if(groundContact || @body.gravityScale > 0){
			var maxAngularVelocity = 360 * @maxSpeed / (2*math.PI*@wheelRadius) * 2.0
			if(math.abs(dx) < 0.1){
				@body.angularVelocity = dx * maxAngularVelocity
			}else if(!@sideContact){
				@body.applyTorque(dx * 50 * forceScale / (@game.physWorld.toPhysScale * @game.physWorld.toPhysScale))
				@body.angularVelocity = math.min(@body.angularVelocity, maxAngularVelocity)
			}
		}else{
			@body.angularVelocity = 0
		}
	},
	
	applyDestY = function(){
		var linearVelocity = @body.linearVelocity
		var dy = clamp((@destPosY - @y) / SNAP_SIZE * 1.0, -1, 1)
		var forceScale = clamp(1 - math.abs(linearVelocity.y) / @maxSpeed, 0, 1)
		// @game.addDebugMessage("applyDestY dy: ${dy}, forceScale: ${forceScale}")
		if(math.abs(dy) < 0.05){
			linearVelocity.y = dy * @maxSpeed * forceScale
			@body.linearVelocity = linearVelocity
		}else{
			@body.applyForceToCenter(vec2(0, dy * 50 * forceScale / @game.physWorld.toPhysScale))
		}
	},
	
	updateDestPos = function(){
		if(@groundContact){
			@destPosX && @applyDestX()
		}else{
			var x = @body.linearVelocity.x / SNAP_SIZE
			// @game.addDebugMessage("fix pos by speed: ${x}")
			var edge = 2.7
			@destPosX = @snapPos(@x, x > edge ? 0.5 : x < -edge ? -0.5 : 0)
			@ladderContact && @applyDestX()
		}
		@destPosY && @applyDestY()
	},
	
	update = function(){
		if(!@body || @isDead){
			return
		}
		@updateContacts()
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
			
			@dir.visible = true
			@dir.angle = @moveDir.angle
			
			var groundContact = @groundContact
			var sensorSize = 0.3
			if(math.abs(@moveDir.x) > sensorSize){
				var side = @moveDir.x > 0 ? 1 : -1
				@destPosX = @snapPos(@x, side)
				@setSideFlip(-side)
				if(!@ladderContact && @pitContact){
					var speedK = math.abs(@body.linearVelocity.x) / @maxSpeed
					speedK > 0.7 && @body.gravityScale = 0.1
				}
				@applyDestX(side)
			}
			if(@moveDir.y < -0.5 && groundContact && @game.time - @jumpTime > 0.1){
				@destPosY = null
				@jumpTime = @game.time
				var jumpForce = 400*0.8 / @game.physWorld.toPhysScale
				
				var size = TILE_SIZE*2 * 1.4
				var a = @pos + vec2(-TILE_SIZE*2*0.45 + TILE_SIZE*2 * (side || 0), @wheelRadius - TILE_SIZE*2*2.35) // 2.3)
				var b = a + vec2(TILE_SIZE*2*0.9, size)
				
				var collided = false
				@game.physWorld.queryAABB(PhysAABB(a, b), function(fixture, body){
					// print "queryAABB, cat: ${fixture.categoryBits}, aabb: (${a.x|0} ${a.y|0}) (${b.x|0} ${b.y|0})"
					if(fixture.categoryBits & PHYS_CAT_BIT_SOLID != 0){
						jumpForce *= 0.7
						collided = true
						// @game.addDebugMessage("fix jump force (time: ${@game.time})")
						return false
					}
				})
				
				@game.physDebugDraw && ColorRectSprite().attrs {
					pos = a,
					size = b - a,
					color = collided ? Color.RED : Color.GREEN,
					opacity = 0.2,
					parent = @game.mapLayers[MAP_LAYER_DEBUG],
				}.addTweenAction {
					duration = 2.0,
					opacity = 0,
					detachTarget = true,
				}
				
				@body.applyForceToCenter(vec2(0, -jumpForce))
				groundContact.fixture.body.applyForce(vec2(0, jumpForce), groundContact.point)
			}else if(@ladderContact && math.abs(@moveDir.y) > sensorSize){ // || @moveDir.y > 0){
				// @destPosX = @snapPos(@x + (side || 0))
				@destPosY = @snapPos(@y, @moveDir.y > 0 ? 1 : -1)
				// @applyDestY()
				// @game.addDebugMessage("process move y in ladderContact: ${@destPosY}, gravityScale: ${@body.gravityScale}")
				if(@moveDir.x == 0){
					@destPosX = @snapPos(@x)
					// @applyDestX()
				}
			}else if(@ladderContact){
				@destPosY = @snapPos(@y)
				// @applyDestY()
				if(@moveDir.x == 0){
					@destPosX = @snapPos(@x)
					// @applyDestX()
				}
			}else if(@destPosY){
				// @applyDestY()
			}
		}else{
			@dir.visible = false
			// @updateDestPos()
		}
		// super()
	},
	
	update = function(){
		if(!@body || @isDead){
			return
		}
		@updateContacts()
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
			
			@dir.visible = true
			@dir.angle = @moveDir.angle
			
			var groundContact = @groundContact
			var sensorSize = 0.3
			if(math.abs(@moveDir.x) > sensorSize){
				var side = @moveDir.x > 0 ? 1 : -1
				@destPosX = @snapPos(@x, side)
				@setSideFlip(-side)
				if(!@ladderContact && @pitContact){
					var speedK = math.abs(@body.linearVelocity.x) / @maxSpeed
					speedK > 0.7 && @body.gravityScale = 0.1
				}
				@applyDestX(side)
			}
			if(@moveDir.y < -0.5 && groundContact && @game.time - @jumpTime > 0.1){
				@destPosY = null
				@jumpTime = @game.time
				var jumpForce = 400*0.8 / @game.physWorld.toPhysScale
				
				var size = TILE_SIZE*2 * 1.4
				var a = @pos + vec2(-TILE_SIZE*2*0.45 + TILE_SIZE*2 * (side || 0), @wheelRadius - TILE_SIZE*2*2.35) // 2.3)
				var b = a + vec2(TILE_SIZE*2*0.9, size)
				
				var collided = false
				@game.physWorld.queryAABB(PhysAABB(a, b), function(fixture, body){
					// print "queryAABB, cat: ${fixture.categoryBits}, aabb: (${a.x|0} ${a.y|0}) (${b.x|0} ${b.y|0})"
					if(fixture.categoryBits & PHYS_CAT_BIT_SOLID != 0){
						jumpForce *= 0.7
						collided = true
						// @game.addDebugMessage("fix jump force (time: ${@game.time})")
						return false
					}
				})
				
				@game.physDebugDraw && ColorRectSprite().attrs {
					pos = a,
					size = b - a,
					color = collided ? Color.RED : Color.GREEN,
					opacity = 0.2,
					parent = @game.mapLayers[MAP_LAYER_DEBUG],
				}.addTweenAction {
					duration = 2.0,
					opacity = 0,
					detachTarget = true,
				}
				
				@body.applyForceToCenter(vec2(0, -jumpForce))
				groundContact.fixture.body.applyForce(vec2(0, jumpForce), groundContact.point)
			}else if(@ladderContact && math.abs(@moveDir.y) > sensorSize){ // || @moveDir.y > 0){
				// @destPosX = @snapPos(@x + (side || 0))
				@destPosY = @snapPos(@y, @moveDir.y > 0 ? 1 : -1)
				// @applyDestY()
				// @game.addDebugMessage("process move y in ladderContact: ${@destPosY}, gravityScale: ${@body.gravityScale}")
				if(@moveDir.x == 0){
					@destPosX = @snapPos(@x)
					// @applyDestX()
				}
			}else if(@ladderContact){
				@destPosY = @snapPos(@y)
				// @applyDestY()
				if(@moveDir.x == 0){
					@destPosX = @snapPos(@x)
					// @applyDestX()
				}
			}else if(@destPosY){
				// @applyDestY()
			}
		}else{
			@dir.visible = false
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
			@dir.pos = @pos = @body.pos + @posShift
			var run = #@body.linearVelocity > TILE_SIZE * 2
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
		
		@light.pos = @pos + vec2(math.random(-0.01, 0.01) * TILE_SIZE, math.random(-0.01, 0.01) * TILE_SIZE)
		@light.radius = @lightTileRadius * @lightTileRadiusScale * TILE_SIZE * math.random(0.99, 1.01)
		
		@game.playerTargetTile.pos = @game.tileToCenterPos(@tileX, @tileY)	
	},
	
}