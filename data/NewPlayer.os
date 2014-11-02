NewPlayer = extends Player {
	__construct = function(game, name){
		super(game, name)
		
		@body = null
		@addTimeout(2, function(){
			var bodyDef = PhysBodyDef()
			bodyDef.type = PHYS_BODY_DYNAMIC
			bodyDef.pos = @pos
			bodyDef.linearDamping = 0.95
			bodyDef.angularDamping = 0.95
			bodyDef.isSleepingAllowed = false
			@body = @game.physWorld.createBody(bodyDef)
			
			var fixtureDef = PhysFixtureDef()
			fixtureDef.type = PHYS_SHAPE_CIRCLE
			fixtureDef.circleRadius = TILE_SIZE / 2 * 0.98
			fixtureDef.categoryBits = PHYS_CAT_BIT_PLAYER
			fixtureDef.maskBits = PHYS_CAT_BIT_GROUND
			fixtureDef.friction = 0.2
			fixtureDef.restitution = 0.2
			fixtureDef.density = 1
			@body.createFixture(fixtureDef)
		})
	},
	
	cleanup = function(){
		@game.physWorld.destroyBody(@body)
		@body = null
		
		super()
	},
	
	update = function(){
		if(@game.moveJoystick.active && !@isDead){
			@moveDir = @game.moveJoystick.dir
			// @updateMoveDir()
			
			@body.angularVelocity = 360 * 2.0 * @moveDir.x
			@body.applyForceToCenter(vec2(@moveDir.x * 2000, 0))
		}else{
			// @moveDir = vec2(0, 0)
			@body.angularVelocity = 0
		}
		// super()
		if(@body){
			@pos = @body.pos - vec2(0, TILE_SIZE / 2 * 0.01)
		}
		
		@light.pos = @pos + vec2(math.random(-0.02, 0.02) * TILE_SIZE, math.random(-0.02, 0.02) * TILE_SIZE)
		@light.radius = @lightTileRadius * @lightTileRadiusScale * TILE_SIZE * math.random(0.98, 1.02)
		
		@game.playerTargetTile.pos = @game.tileToCenterPos(@tileX, @tileY)	
	},
	
}