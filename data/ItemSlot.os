ItemSlot = extends Box9Sprite {
	__construct = function(){
		super()
		@resAnim = res.get("slot")
		@size = vec2(SLOT_SIZE, SLOT_SIZE)
	},
}
