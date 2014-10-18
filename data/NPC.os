NPC = extends Monster {
	__construct = function(game, type, typeName){
		super(game, type)
		@typeName = typeName
		@warnOnMove = false
	},
	
	checkMoveDir = function(){
		if(@pushingByEnt !== @game.player && @tileY == @game.player.tileY){
			var dx = math.abs(@tileX - @game.player.tileX)
			if(dx == 1){
				@moveDir.x = @moveDir.y = 0
			}else if(dx == 2){
				@moveDir.x = @tileX < @game.player.tileX ? 1 : -1
				@moveDir.y = 0
			}
		}
		super()
	},
}