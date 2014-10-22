NPC_Trader = extends NPC {
	__construct = function(game, type){
		super(game, type, "trader")
		@thinkTime = 0
		@tutorial = null
	},
	
	cleanup = function(){
		@tutorial.detach()
		@tutorial = null
		super()
	},
	
	runTutorial = function(target){
		@tutorial || @checkTutorial(target)
	},
	
	checkTutorial = function(target){
		@tutorial && throw "tutorial is already started"
		target || target = @game.speechBubbles
		if(!GAME_SETTINGS.doneTutorials.touchTrader){
			@tutorial = Tutorial.animateTouchEntity {
				target = target,
				ent = this,
				updateCallback = function(){
					var dx = math.abs(@tileX - @game.player.tileX)
					var dy = math.abs(@tileY - @game.player.tileY)
					if(dx > 3 || dy > 1 || GAME_SETTINGS.doneTutorials.touchTrader){
						@tutorial.detach()
						@tutorial = null
						// @runTutorial(target)
					}
				},
			}
		}
	},
	
	thinkAboutPlayer = function(){
		if(!Player.pickItemType){
			@game.bubbleItem(this, @game.player.tileX, @game.player.tileY, randItem([ITEM_TYPE_SHOVEL, ITEM_TYPE_SHOPPING]))
		}else if(@game.time - @thinkTime > 2){
			@thinkTime = @game.time
			if(math.random() < 0.2){
				@game.bubbleItem(this, @game.player.tileX, @game.player.tileY, randItem(SHOP_ITEMS_INFO.keys))
			}
		}
	},
	
	checkMoveDir = function(){
		super()
		if(!GAME_SETTINGS.doneTutorials.touchTrader){
			if(!@moving && !@moveAnimatedX && !@moveAnimatedY && !@tutorial && !Player.pickItemType){
				var dx = math.abs(@tileX - @game.player.tileX)
				var dy = math.abs(@tileY - @game.player.tileY)
				dx <= 3 && dy <= 1 && @runTutorial()
			}
			if(@tutorial){
				@moveDir.x = @moveDir.y = 0
			}
		}
	},
	
	onClick = function(ev){
		@game.openShop(this)
	},	
}