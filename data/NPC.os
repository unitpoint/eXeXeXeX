NPC = extends Monster {
	__construct = function(game, type, typeName){
		super(game, type)
		@typeName = typeName
		@warnOnMove = false
	},
	
	initHudStamina = function(){
		// no stamina bar
	},
	
	thinkAboutPlayer = function(){
	},
	
	checkMoveDir = function(){
		if(@pushingByEnt !== @game.player && @tileY == @game.player.tileY){
			var dx = math.abs(@tileX - @game.player.tileX)
			if(dx == 1){
				@moveDir.x = @moveDir.y = 0
				@thinkAboutPlayer()
			}else if(dx <= 3){
				@moveDir.x = @tileX < @game.player.tileX ? 1 : -1
				@moveDir.y = 0
				@thinkAboutPlayer()
			}
		}
		super()
	},
}