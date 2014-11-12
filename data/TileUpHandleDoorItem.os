TileUpHandleDoorItem = extends TileItem {
	STATE_CLOSED = 0,
	STATE_OPENING = 1,
	STATE_OPENED = 2,
	STATE_CLOSING = 3,
	
	__object = {
		contacts = {},
		doorBody = null,
	},
	
	__construct = function(game, type){
		super(game, type)
		// @parent = @game.mapLayers[MAP_LAYER_TILE_FRONT_DOOR]
		
		var elem = ELEMENTS_LIST[@type]
		elem.transparent || @sprite.fixAnimRect(0.4)
		
		@handle = Sprite().attrs {
			resAnim = res.get(elem.handle),
			pivot = vec2(0.51, 0.51),
			pos = @size / 2,
			scale = elem.handleScale || 1,
			priority = 2,
			parent = @sprite,
		}
		@handleShadow = Sprite().attrs {
			resAnim = res.get(elem.handleShadow),
			pivot = @handle.pivot,
			pos = @handle.pos + vec2(@width * 0.02, @height * 0.05),
			scale = @handle.scale,
			opacity = 0.5,
			priority = 1,
			parent = @sprite,
		}
		
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
		fixtureDef.setPolygonAsBounds(vec2(-1.0, -0.5) * halfSize - vec2(TILE_SIZE/2, 0), vec2(1.0, 0.5) * halfSize + vec2(TILE_SIZE/2, 0))
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
		
		// @doorBody.testContactCallback = @testContact.bind(this)
		@doorBody.beginContactCallback = @registerContact.bind(this)
		// @doorBody.endContactCallback = @unregisterContact.bind(this)
	},
	
	/* testContact = function(contact, i){
		var storedContact = @contacts[contact.id]
		if(storedContact){
			// var dot = contact.normal.dot(VEC2_UP)
			// var angle = math.deg(math.acos(dot))
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
	}, */
	
	registerContact = function(contact, i){
		if(contact.getFixture(1-i).isSensor){
			@open()
			// @game.addDebugMessage("[+ ${contact.id}] cat: "..contact.getFixture(i).categoryBits)
			return
		}
		// var dot = contact.normal.dot(VEC2_UP)
		// var angle = math.deg(math.acos(dot))
		/* @contacts[contact.id] = {
			id = contact.id,
			fixture = contact.getFixture(i),
			normal = contact.normal,
			point = contact.point,
			// angle = angle,
			// dot = dot,
			time = @game.time,
		} */
		// @game.addDebugMessage("[+ ${contact.id}] fix_id: ${contact.getFixture(i).id}, cat: ${contact.getFixture(i).categoryBits}, angle: ${angle|0}, p: ${contact.point.x|0}, ${contact.point.y|0}")
		// @game.addDebugMessage("[+ ${contact.id}] angle: ${angle}, contacts: ${#@contacts}")
	},
	
	/* unregisterContact = function(contact, i){
		delete @contacts[contact.id]
		// @game.addDebugMessage("[- ${contact.id}] fix_id: ${contact.getFixture(i).id}, cat: ${contact.getFixture(i).categoryBits}")
		// @game.addDebugMessage("[- ${contact.id}] contacts: ${#@contacts}")
	}, */
	
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
		
		var destAngle = 360*2.3
		@handleAction = @handle.addTweenAction {
			duration = (1 - @handle.angle / destAngle) * 1.0,
			angle = destAngle,
			ease = Ease.CUBIC_IN_OUT,
			tickCallback = function(){
				@handleShadow.angle = @handle.angle
			},
			doneCallback = function(){
				// @tile.back.visible = true
				// @tile.game.updateMapTiles(@tile.tileX-1, @tile.tileY-1, @tile.tileX+1, @tile.tileY+1, true)
				@handleAction = @sprite.addTweenAction {
					duration = 1.0, // (1 - @openState) * 1.0,
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
							@close()
						})
					},
				}
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
		
		/* @timeoutHandle = @addTimeout(0.4, function(){
			@timeoutHandle = null
			var ent = @tile.game.getTileEnt(@tile.tileX, @tile.tileY)
			if(ent){
				@open()
			}
		}) */
		
		@handleAction = @sprite.addTweenAction {
			duration = 1.0,
			y = 0,
			ease = Ease.CUBIC_IN_OUT,
			tickCallback = function(){
				@updateLinkPos()
			},
			doneCallback = function(){
				@state = @STATE_CLOSED
				// @tile.back.visible = false
				// @tile.game.updateMapTiles(@tile.tileX-1, @tile.tileY-1, @tile.tileX+1, @tile.tileY+1, true)
				@handleAction = @handle.addTweenAction {
					duration = 1.0,
					angle = 0,
					ease = Ease.CUBIC_IN_OUT,
					tickCallback = function(){
						@handleShadow.angle = @handle.angle
					},
					doneCallback = function(){
						@sound.fadeOut(1.5); @sound = null
						@handleAction = null
					},
				}
			},
		}
	},
}