TILES_INFO = {
	[ELEM_TYPE_EMPTY] = {
		// strength = 0,
		passable = true,
		transparent = true,
	},
	[TILE_TYPE_LADDER] = {
		// strength = 0,
		passable = true,
		transparent = true,
		item = ITEM_TYPE_LADDER,
		isItem = true, // kind of tile, if it's item then we use special animation of removing
	},
	[TILE_TYPE_GRASS] = {
		strength = 6,
		item = ITEM_TYPE_TILE_DIRT_01,
	},
	[TILE_TYPE_CHERNOZEM] = {
		variants = 3,
		strength = 6,
		item = ITEM_TYPE_TILE_DIRT_01,
		// damageDelay = 0.1,
	},
	[TILE_TYPE_ROCK] = {
		// variants = 1,
	},
	2 = {
		strength = 50,
		variants = 2,
		glowing = true,
	},
	3 = {
		strength = 30,
		glowing = true,
	},
	[TILE_TYPE_DOOR_01] = {
		class = "DoorTile",
		// door = true,
		handle = "door-handle",
		handleShadow = "door-handle-shadow",
	},
	[TILE_TYPE_TRADE_STOCK] = {
		variants = 4,
	},
}
