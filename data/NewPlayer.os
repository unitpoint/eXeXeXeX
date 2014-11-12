NewPlayer = extends Actor {
	__object = {
		flipX = 1,
		flipY = 1,
		
		jumpTime = 0,
		body = null,
		contacts = {},
		groundContact = null,
		sideContact = null,
		ladderContact = null,
		pitContact = null,
		
		maxSpeed = TILE_SIZE * 10,
		
		breathingAction = null,
		breathingSpeed = 1.0,
		
		isDead = false,
		attacking = false,
		
		waddleEnabled = true,
		waddleStarted = false,
	},
	
	getState = function(){
		return {
			x = @x,
			y = @y,
		}
	},
	
	loadState = function(state){
		@game.initEntPos(this, state.x, state.y)
		@createPhysBody()
	},
	
	initEntity = function(ent){
		@game.initEntPos(this, ent.x, ent.y)
		@createPhysBody()
	},
	
	__construct = function(game, type){
		super()
		// super(game, type)
		
		@cull = true
		@game = game
		@type = type
		
		var elem = ELEMENTS_LIST[type] || throw "unknown entity type: ${type}"
		elem.isEntity || throw "required entity element but found: ${elem}"
		
		@name = elem.res || throw "res is not found in elem: ${elem}"
		
		@touchChildrenEnabled = false
		@pivot = vec2(0.5, 0.5)
		@size = vec2(elem.width, elem.height)
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
			parent = @flipLayer,
		}
		
		@baseScale = @size / @sprite.size
		@flipLayer.scale = @baseScale
		
		@sprite.scale = 0.9
		
		@addUpdate(@update.bind(this))
		// @addUpdate(0.1, @checkFalling.bind(this))		
		
		var elem = ELEMENTS_LIST[type]
		var size = math.min(elem.width, elem.height)
		
		@wheelRadius = size / 2 * 0.8
		@posShift = vec2(0, -(size / 2 - @wheelRadius))
		
		@dir = Sprite().attrs {
			resAnim = res.get("dir"),
			pivot = vec2(-6, 0.5),
			visible = false,
			parent = @game.mapLayers[MAP_LAYER_PLAYER_DIR],
		}
		
		@lightRadius = 8 * TILE_SIZE
		@light = Light().attrs {
			name = "light-01",
			shadowColor = Color(0.1, 0.1, 0.1),
			// shadowColor = Color(0.4, 0.4, 0.4),
			// radius = 0, // @lightTileRadius * @lightTileRadiusScale * TILE_SIZE,
			color = Color(0.8, 0.9, 0.9),
			// tileRadius = @lightTileRadius,
			// parent = this,
		}
		@game.addLight(@light)
		
		@parent = game.mapLayers[MAP_LAYER_PLAYER]
		@startBreathing()
	},
	
	createPhysBody = function(){
		@body && throw "body is already created"
		var elem = ELEMENTS_LIST[@type]
		
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
		fixtureDef.maskBits = PHYS_CAT_BIT_SOLID | PHYS_CAT_BIT_LADDER | PHYS_CAT_BIT_PIT | PHYS_CAT_BIT_HELPER | PHYS_CAT_BIT_DOOR
		fixtureDef.friction = elem.physFriction || 0.4
		fixtureDef.restitution = elem.physRestitution || 0.0
		fixtureDef.density = elem.physDensity || 1
		@body.createFixture(fixtureDef)
		
		@body.testContactCallback = @testContact.bind(this)
		@body.beginContactCallback = @registerContact.bind(this)
		@body.endContactCallback = @unregisterContact.bind(this)
	},
	
	centerSprite = function(){
		@attacking || @moveLayer.replaceTweenAction {
			name = "move",
			duration = 0.1,
			pos = @centerPos,
			angle = 0,
		}
	},
	
	setSideFlip = function(newScaleX){
		if(newScaleX != @flipX){
			@flipLayer.replaceTweenAction {
				name = "scaleX",
				duration = 0.2, // * @maxSpeed,
				scaleX = (@flipX = newScaleX) * @baseScale.x,
				ease = Ease.CUBIC_IN_OUT,
			}
		}
	},
	
	setUpFlip = function(newScaleY){
		if(newScaleY != @flipY){
			@flipLayer.replaceTweenAction {
				name = "scaleY",
				duration = 0.3, // * @maxSpeed,
				scaleY = (@flipY = newScaleY) * @baseScale.y,
				ease = Ease.CUBIC_IN_OUT,
			}
		}
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
	
	startWaddle = function(){
		if(@waddleEnabled){
			var side = @body.linearVelocity.x > 0 ? 1 : -1
			@replaceAction("moveAngle", RepeatForeverAction(SequenceAction(
				TweenAction {
					duration = 0.15, // * @maxSpeed,
					angle = -5 * side,
					// ease = Ease.CUBIC_IN_OUT,
				},
				TweenAction {
					duration = 0.15, // * @maxSpeed,
					angle = 5 * side,
					// ease = Ease.CUBIC_IN_OUT,
				},
			)))
		}
	},
	
	stopWaddle = function(){
		@replaceTweenAction {
			name = "moveAngle",
			duration = 0.1, // * @maxSpeed,
			angle = 0,
		}
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
	
	applyHorizForce = function(dx){
		var linearVelocity = @body.linearVelocity
		var forceScale = clamp(1 - math.abs(linearVelocity.x) / @maxSpeed, 0, 1)
		var groundContact = @groundContact
		forceScale = forceScale * math.max(0.25, groundContact.dot || 0)
		@body.applyForceToCenter(vec2(dx * (groundContact ? 10000 : 5000) * forceScale, 0))

		if(linearVelocity.x < -@maxSpeed){
			linearVelocity.x = -@maxSpeed
		}else if(linearVelocity.x > @maxSpeed){
			linearVelocity.x = @maxSpeed
		}
		@body.linearVelocity = linearVelocity
		
		if((groundContact || @body.gravityScale > 0)){ // && !@sideContact){
			@body.applyTorque(dx * 100000)
			
			var maxAngularVelocity = 360 * @maxSpeed / (2*math.PI*@wheelRadius) * 1.0
			var angularVelocity = @body.angularVelocity
			if(angularVelocity < -maxAngularVelocity){
				angularVelocity = -maxAngularVelocity
			}else if(angularVelocity > maxAngularVelocity){
				angularVelocity = maxAngularVelocity
			}
			@body.angularVelocity = angularVelocity
		}else{
			@body.angularVelocity = 0
		}
	},
	
	applyVertForce = function(dy){
		var linearVelocity = @body.linearVelocity
		var forceScale = clamp(1 - math.abs(linearVelocity.y) / @maxSpeed, 0, 1)
		@body.applyForceToCenter(vec2(0, dy * 5000 * forceScale))

		if(linearVelocity.y < -@maxSpeed){
			linearVelocity.y = -@maxSpeed
		}else if(linearVelocity.y > @maxSpeed * 2){
			linearVelocity.y = @maxSpeed * 2
		}
		@body.linearVelocity = linearVelocity
	},
	
	snapXToLadder = function(){
		var body = @ladderContact.fixture.body
		// var ladder = body.item as TileLadderItem || throw "ladder required"
		var dx = clamp((body.pos.x - @x) / TILE_SIZE, -1, 1)
		var linearVelocity = @body.linearVelocity
		if((dx < 0) != (linearVelocity.x < 0)){
			// return
			// dx = -dx
			dx = dx < 0 ? 1 : -1
		}
		var forceScale = clamp(1 - math.abs(linearVelocity.x) / @maxSpeed, 0, 1)
		if(math.abs(dx) < 0.2){
			linearVelocity.x = dx * @maxSpeed * forceScale
		}else{
			@body.applyForceToCenter(vec2(dx * 5000 * forceScale, 0))
		}
		if(linearVelocity.x < -@maxSpeed){
			linearVelocity.x = -@maxSpeed
		}else if(linearVelocity.x > @maxSpeed){
			linearVelocity.x = @maxSpeed
		}
		@body.linearVelocity = linearVelocity			
	},
	
	snapYToLadder = function(){
		// var body = @ladderContact.fixture.body
		// var ladder = body.item as TileLadderItem || throw "ladder required"
		var destY = (math.round(@y / TILE_SIZE) + 0) * TILE_SIZE
		var dy = clamp((destY - @y) / TILE_SIZE, -1, 1)
		var linearVelocity = @body.linearVelocity
		if((dy < 0) != (linearVelocity.y < 0)){
			// return
			// dy = -dy
			dy = dy < 0 ? 1 : -1
		}
		var forceScale = clamp(1 - math.abs(linearVelocity.y) / @maxSpeed, 0, 1)
		if(math.abs(dy) < 0.2){
			linearVelocity.y = dy * @maxSpeed * forceScale
		}else{
			@body.applyForceToCenter(vec2(0, dy * 5000 * forceScale))
		}
		if(linearVelocity.y < -@maxSpeed){
			linearVelocity.y = -@maxSpeed
		}else if(linearVelocity.y > @maxSpeed * 2){
			linearVelocity.y = @maxSpeed * 2
		}
		@body.linearVelocity = linearVelocity			
	},
	
	update = function(){
		if(!@body || @isDead){
			return
		}
		@updateContacts()
		if(@ladderContact){
			@body.gravityScale = 0
		}else{
			@body.gravityScale = 1
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
				@setSideFlip(-side)
				if(!@ladderContact && @pitContact){
					var speedK = math.abs(@body.linearVelocity.x) / @maxSpeed
					speedK > 0.7 && @body.gravityScale = 0.1
				}
				@applyHorizForce(@moveDir.x)
			}
			if(@ladderContact){
				if(math.abs(@moveDir.y) > sensorSize){
					@applyVertForce(@moveDir.y)
				}
				if(!side){
					@snapXToLadder()
				}
			}else if(@moveDir.y < -0.5 && groundContact && @game.time - @jumpTime > 0.1){
				@jumpTime = @game.time
				var jumpForce = 40000
				
				var size = TILE_SIZE*2 * 1.4
				var a = @pos + vec2(-TILE_SIZE*2*0.3 + TILE_SIZE*2 * (side || 0), @wheelRadius - TILE_SIZE*2*2.35) // 2.3)
				var b = a + vec2(TILE_SIZE*2*0.6, size)
				
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
			}
		}else{
			@dir.visible = false
			
			if(@ladderContact){
				@body.linearVelocity = @body.linearVelocity * 0.5
				@snapXToLadder()
				@snapYToLadder()
			}else if(@groundContact){
				@body.linearVelocity = @body.linearVelocity * 0.5
			}
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
		
		@light.pos = @pos // + vec2(math.random(-0.01, 0.01) * TILE_SIZE, math.random(-0.01, 0.01) * TILE_SIZE)
		@light.radius = @lightRadius // * math.random(0.99, 1.01)
	},
	
}