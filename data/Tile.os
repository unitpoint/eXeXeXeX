Tile = extends BaseTile {
	__construct = function(game, x, y){
		super(game, x, y)
		
		@frontType = @game.getFrontType(x, y)
		var frontType = @frontType == TILE_TYPE_BLOCK ? TILE_TYPE_ROCK : @frontType
		
		@backType = @game.getBackType(x, y)
		var backType = @backType == TILE_TYPE_BLOCK ? TILE_TYPE_ROCK : @backType
		
		var frontResName = @game.getTileResName("tile", frontType, x, y, TILES_INFO[frontType].variants)
		@front = Sprite().attrs {
			resAnim = res.get(frontResName),
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			priority = 2,
			parent = this
		}
		@front.scale = @size / @front.size
		
		var backResName = @game.getTileResName("tile", backType, x, y, TILES_INFO[backType].variants)
		@back = Sprite().attrs {
			resAnim = res.get(backResName),
			pivot = vec2(0, 0),
			pos = vec2(0, 0),
			priority = 1,
			parent = this
		}
		if(backType < 16)
			@back.color = Color(0.2, 0.2, 0.2)
		else
			@back.color = Color(0.7, 0.7, 0.7)
		@back.scale = @size / @back.size
		
		if(@frontType == TILE_TYPE_EMPTY){
			@front.visible = false
		}else if(@frontType != TILE_TYPE_LADDERS){
			@back.visible = false
		}
		
		@itemType = @game.getItemType(x, y)
		if(@itemType > 0){
			var itemResName = @game.getTileResName("item", @itemType, x, y, ITEMS_INFO[@itemType].variants)
			@item = Sprite().attrs {
				resAnim = res.get(itemResName),
				pivot = vec2(0.5, 0.5),
				pos = @size/2,
				priority = 3,
				parent = this,
			}
			@item.scale = @size / math.max(@item.width, @item.height)
		}		
	},
}