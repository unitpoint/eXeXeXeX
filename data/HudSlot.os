HudSlot = extends ItemSlot {
	__construct = function(game, slotNum){
		super(game, Backpack, slotNum)
		@opacity = 0.75
	},
	
	__set@type = function(type){
		@clearItem()
		for(var _, hudSlot in @game.hudSlots){
			if(hudSlot.type == type){
				hudSlot.clearItem()
			}
		}
		super(type)
		@count = @owner.pack.numItemsByType[type]
	},
}