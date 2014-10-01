Player = extends Entity {
	__construct = function(game, name){
		super(game, name)
		@parent = game.layers[LAYER_PLAYER]
		@isPlayer = true
		@startBreathing()
		@addUpdate(0.3, @updatePlayerSector.bind(this))
	},
	
	updatePlayerSector = function(){
		for(var _, tile in @game.tiles){
			var ent = @getTileEnt(tile.tileX, tile.tileY)
			if(ent is Monster){
				ent.queryAI()
			}
		}
		/* for(var x = -2; x <= 2; x++){
			for(var y = -2; y <= 2; y++){
				// x == 0 && y == 0 && continue
				var ent = @getTileEnt(@tileX + x, @tileY + y)
				if(ent is Monster){
					ent.queryAI()
				}
			}
		} */
	},
	
	update = function(){
		super()
	},
}