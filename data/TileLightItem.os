local function arrayToColor(arr){
	return Color(arr[0], arr[1], arr[2])
}

TileLightItem = extends TileItem {
	__construct = function(game, type){
		super(game, type)
		
		var elem = ELEMENTS_LIST[type]
		@light = Light().attrs {
			name = elem.lightResName || "light-01",
			shadowColor = elem.lightShadowColor ? arrayToColor(elem.lightShadowColor) : Color(0.0, 0.0, 0.0),
			radius = elem.lightRadius || TILE_SIZE * 5,
			color = elem.lightColor ? arrayToColor(elem.lightColor) : Color(1.0, 1.0, 1.0),
			angularVelocity = elem.lightAngularVelocity || 0,
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