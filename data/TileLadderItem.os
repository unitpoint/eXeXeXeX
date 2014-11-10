TileLadderItem = extends TileItem {
	__construct = function(game, type){
		super(game, type)
	},
	
	createPhysBody = function(){
		super()
		
		var size = @size
		var fixtureDef = PhysFixtureDef()
		// fixtureDef.setPolygonAsBounds(vec2(-size.x * 0.15, -size.y), vec2(size.x * 0.15, 0))
		fixtureDef.setPolygonAsBounds(vec2(-size.x * 0.1, -size.y * 0.5), vec2(size.x * 0.1, 0))
		fixtureDef.categoryBits = PHYS_CAT_BIT_LADDER
		fixtureDef.isSensor = true
		@body.createFixture(fixtureDef)
	},
}