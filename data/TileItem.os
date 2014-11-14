TileItem = extends Actor {
	SHADOW_OFFS = vec2(5, 5),
	
	__object = {
		tileX = 0,
		tileY = 0,
		body = null,
	},
	
	getState = function(){
		return {
			tx = @tileX,
			ty = @tileY,
		}
	},
	
	loadState = function(state){
		@tileX, @tileY = state.tx, state.ty
		@game.initTileItemPos(this, state.tx, state.ty)
		@createPhysBody()
	},
	
	initItem = function(item){
		@tileX, @tileY = item.tx, item.ty
		@game.initTileItemPos(this, item.tx, item.ty)
		@createPhysBody()
	},
	
	__construct = function(game, type){
		super()
		// super(game, type)
		
		@cull = true
		@game = game
		@type = type
		@touchChildrenEnabled = false
		@parent = game.mapLayers[MAP_LAYER_TILE_ITEM]
		
		var elem = ELEMENTS_LIST[type] || throw "unknown entity type: ${type}"
		elem.isItem || throw "item element required: ${elem}"
		elem.cols || throw "cols required: ${elem}"
		elem.rows || throw "rows required: ${elem}"
		
		@name = elem.res || throw "res is not found in elem: ${elem}"
		@size = vec2(elem.cols * TILE_SIZE, elem.rows * TILE_SIZE)
		
		@sprite = Sprite().attrs {
			resAnim = res.get(@name),
			// size = @size,
			parent = this,
		}
		@spriteBaseSize = @sprite.size
		@sprite.scale = @size / @spriteBaseSize
		@sprite.size = @size
		
		if(elem.noShadow){
			@shadow = @shadowBaseSize = null
		}else{
			@shadow = Sprite().attrs {
				resAnim = @sprite.resAnim,
				// size = @size,
				// pos = @pos + vec2(10, 10),
				color = Color(0.1, 0.1, 0.1, 0.8),
				parent = game.mapLayers[MAP_LAYER_TILE_ITEM_SHADOW],
			}
			@shadowBaseSize = @shadow.size
			@shadow.scale = @size / @shadowBaseSize
			@shadow.size = @size
		}
	},
	
	updateLinkPos = function(){
		@shadow.pos = @pos + TileItem.SHADOW_OFFS
	},
	
	__set@pos = function(value){
		super(value)
		@updateLinkPos()
	},
	
	__set@x = function(value){
		super(value)
		@updateLinkPos()
	},
	
	__set@y = function(value){
		super(value)
		@updateLinkPos()
	},
	
	cleanup = function(){
		@body.destroy()
		@shadow.detach()
	},
	
	createPhysBody = function(){
		var halfSize = @size / 2
		var bodyDef = PhysBodyDef()
		bodyDef.type = PHYS_BODY_STATIC
		bodyDef.pos = @pos + halfSize
		// bodyDef.linearDamping = 0.99
		// bodyDef.angularDamping = 0.99
		// bodyDef.isSleepingAllowed = false
		@body = @game.physWorld.createBody(bodyDef)
		@body.item = this
		
		var fixtureDef = PhysFixtureDef()
		// fixtureDef.type = PHYS_SHAPE_POLYGON
		// fixtureDef.setPolygonAsBox(halfSize, center, 0)
		// fixtureDef.setPolygonAsBounds(vec2(0, 0), @size)
		fixtureDef.setPolygonAsBounds(-halfSize, halfSize)
		fixtureDef.categoryBits = PHYS_CAT_BIT_TILE_ITEM
		// fixtureDef.friction = 0.99
		@body.createFixture(fixtureDef)
	},
}