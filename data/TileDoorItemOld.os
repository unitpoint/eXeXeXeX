TileDoorItem = extends TileItem {
	STATE_CLOSED = 0,
	STATE_OPENING = 1,
	STATE_OPENED = 2,
	STATE_CLOSING = 3,
	
	__object = {
		doorBody = null,
	},
	
	__construct = function(game, type){
		super(game, type)
		// @parent = @game.mapLayers[MAP_LAYER_TILE_FRONT_DOOR]
		
		var elem = ELEMENTS_LIST[@type]
		elem.transparent || @sprite.fixAnimRect(0.4)
		
		@openY = -@height * 0.95
		@handleAction = null
		@timeoutHandle = null
		@state = @STATE_CLOSED
		@sound = null
		
		var shadowNewSize = @size + TILE_SIZE * 0.2
		@shadow.scale = shadowNewSize / @shadowBaseSize
		@shadow.size = shadowNewSize
	},
	
	updateLinkPos = function(){
		var pos = @pos + @sprite.pos
		@shadow.pos = pos - vec2(TILE_SIZE * 0.1, 0)
		@doorBody.pos = pos + @size / 2
	},
	
	cleanup = function(){
		@sound.fadeOut(0.5)
		@doorBody.destroy()
		super()
	},
	
	createPhysBody = function(){
		// keep PHYS_CAT_BIT_TILE_ITEM body 
		// to detect origin item place while placing new items
		super()
		
		var halfSize = @size * 0.5
		var bodyDef = PhysBodyDef()
		bodyDef.type = PHYS_BODY_STATIC
		bodyDef.pos = @pos + halfSize
		// bodyDef.linearDamping = 0.99
		// bodyDef.angularDamping = 0.99
		// bodyDef.isSleepingAllowed = false
		@doorBody = @game.physWorld.createBody(bodyDef)
		@doorBody.item = this
		
		var fixtureDef = PhysFixtureDef()
		fixtureDef.setPolygonAsBounds(-halfSize, halfSize)
		fixtureDef.categoryBits = PHYS_CAT_BIT_SOLID | PHYS_CAT_BIT_DOOR
		// fixtureDef.maskBits = PHYS_CAT_BIT_PLAYER | PHYS_CAT_BIT_ENTITY
		@doorBody.createFixture(fixtureDef)
		
		var fixtureDef = PhysFixtureDef()
		fixtureDef.setPolygonAsBounds(vec2(-1.0, -0.5) * halfSize - vec2(TILE_SIZE*2.0, 0), vec2(1.0, 0.5) * halfSize + vec2(TILE_SIZE*2.0, 0))
		fixtureDef.categoryBits = PHYS_CAT_BIT_DOOR
		fixtureDef.maskBits = PHYS_CAT_BIT_PLAYER | PHYS_CAT_BIT_ENTITY
		fixtureDef.isSensor = true
		@doorBody.createFixture(fixtureDef)
		
		var fixtureDef = PhysFixtureDef()
		fixtureDef.setPolygonAsBounds(vec2(-0.5, 0.9) * halfSize, vec2(0.5, 1.0) * halfSize + vec2(0, TILE_SIZE * 0.1))
		fixtureDef.categoryBits = PHYS_CAT_BIT_DOOR
		fixtureDef.maskBits = PHYS_CAT_BIT_PLAYER | PHYS_CAT_BIT_ENTITY
		fixtureDef.isSensor = true
		@doorBody.createFixture(fixtureDef)
		
		@doorBody.beginContactCallback = @registerContact.bind(this)
	},
	
	registerContact = function(contact, i){
		if(contact.getFixture(1-i).isSensor){
			@open()
		}
	},
	
	open = function(){
		if(@state == @STATE_OPENING || @state == @STATE_OPENED){
			return
		}
		@state = @STATE_OPENING
		@removeTimeout(@timeoutHandle); @timeoutHandle = null
		@handleAction.target.removeAction(@handleAction)
		
		@sound.stop()
		var elem = ELEMENTS_LIST[@type]
		elem.openSound && @sound = splayer.play {
			sound = elem.openSound, // "door",
		}
		
		@handleAction = @sprite.addTweenAction {
			duration = 0.15, // (1 - @openState) * 1.0,
			y = @openY,
			ease = Ease.CUBIC_IN_OUT,
			tickCallback = function(){
				@updateLinkPos()
			},
			doneCallback = function(){
				@handleAction = null
				@state = @STATE_OPENED
				@sound.fadeOut(0.5); @sound = null
				@timeoutHandle = @addTimeout(1.0, function(){
					@timeoutHandle = null
					@close()
				})
			},
		}
	},
	
	close = function(){
		if(@state == @STATE_CLOSING || @state == @STATE_CLOSED){
			return
		}
		@state = @STATE_CLOSING
		@removeTimeout(@timeoutHandle); @timeoutHandle = null
		@handleAction.target.removeAction(@handleAction)
		
		@sound.stop()
		var elem = ELEMENTS_LIST[@type]
		elem.closeSound && @sound = splayer.play {
			sound = elem.closeSound, // "door-02",
		}
		
		@handleAction = @sprite.addTweenAction {
			duration = 0.8,
			y = 0,
			ease = Ease.CUBIC_IN_OUT,
			tickCallback = function(){
				@updateLinkPos()
			},
			doneCallback = function(){
				@state = @STATE_CLOSED
				@sound.fadeOut(0.5); @sound = null
				@handleAction = null
			},
		}
	},
}