TileItem = extends Actor {
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
		elem.isItem || throw "required item element but found: ${elem}"
		
		@name = elem.res || throw "res is not found in elem: ${elem}"
		@size = vec2(elem.cols * TILE_SIZE, elem.rows * TILE_SIZE)
		
		@sprite = Box9Sprite().attrs {
			resAnim = res.get(@name),
			size = @size,
			parent = this,
		}
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