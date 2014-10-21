NPC_Trader = extends NPC {
	__construct = function(game, type){
		super(game, type, "trader")
		@thinkTime = 0
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
}