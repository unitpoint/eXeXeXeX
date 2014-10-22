EntItem_SafePack = extends EntItem {
	__construct = function(game, type){
		super(game, type)
	},
	
	getState = function(){
		return super().merge {
			cols = @cols,
			rows = @rows,
			pack = @pack.getState(),
		}
	},
	
	loadState = function(state){
		super(state)
		@cols = clamp(toNumber(state.cols), 1, 4)
		@rows = clamp(toNumber(state.rows), 1, 4)
		@pack = ItemsPack(@cols * @rows)
		@pack.loadState(state.pack)
	},

	initObject = function(levelObj){
		super(levelObj)
		@cols = clamp(toNumber(levelObj.size.x), 1, 4)
		@rows = clamp(toNumber(levelObj.size.y), 1, 4)
		@pack = ItemsPack(@cols * @rows)
		if(levelObj.items){
			@pack.loadState(levelObj.items)
		}else{
			var itemTypes = ITEMS_INFO.keys
			while(#@pack.numItemsByType < @pack.numSlots && #itemTypes > 0){
				var i = math.random(#itemTypes)
				if(itemTypes[i] != ITEM_TYPE_BULLETS){
					@pack.addItem(itemTypes[i])
				}
				delete itemTypes[i]
			}
		}
	},
	
	onClick = function(ev){
		@game.openSafePack(this)
	},
}