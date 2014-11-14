TileLightItem = extends TileItem {
	__construct = function(game, type){
		super(game, type)
		
		var elem = ELEMENTS_LIST[type]
		@light = Light().attrs {
			name = elem.lightResName || "light-01",
			shadowColor = elem.lightShadowColor || Color.BLACK, // (0.0, 0.0, 0.0),
			radius = elem.lightRadius || TILE_SIZE * 5,
			color = elem.lightColor || Color.WHITE, // (1.0, 1.0, 1.0),
			frontColor = elem.lightFrontColor || Color.BLACK,
			angularVelocity = elem.lightAngularVelocity || 0,
			angle = elem.lightAngularVelocity ? math.random(360) : 0,
		}
		@game.addLight(@light)
	},
	
	updateLinkPos = function(){
		@light.pos = @pos + @size / 2
	},
	
	cleanup = function(){
		@game.removeLight(@light)
		super()
	},
}