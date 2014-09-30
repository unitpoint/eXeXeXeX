BaseTile = extends Actor {
	__construct = function(game, x, y){
		super()
		@game = game
		@tileX = x
		@tileY = y
		// @frontType = TILE_TYPE_EMPTY
		// @backType = TILE_TYPE_EMPTY
		// @itemType = ITEM_TYPE_EMPTY
		@size = vec2(TILE_SIZE, TILE_SIZE)
		@pos = game.tileToPos(x, y)
		@priority = TILE_BASE_PRIORITY
		@touchChildrenEnabled = false
		
		@parent = game.layers[LAYER_TILES]
		game.tiles["${x}-${y}"] = this
	},
	
	__get@openState = function(){
		return 0.0
	},
	
	pickByEnt = function(ent){
		
	},
}
