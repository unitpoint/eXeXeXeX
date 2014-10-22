EntItem = extends Entity {
	__construct = function(game, type){
		super(game, type, "ent-item")
		@parent = game.layers[LAYER_MONSTERS]
		@waddleEnabled = false
	},
	
	setSideFlip = function(newScaleX){
	},
	
	checkMoveDir = function(){
		super()
		@moveDir.x = @moveDir.y = 0
	},
}