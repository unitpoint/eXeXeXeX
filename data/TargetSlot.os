TargetSlot = extends ItemSlot {
	__construct = function(game, owner){
		super(game, owner, null, "slot-target")
		@_isTarget = true
		// @color = Color(1, 1, 0.8)
		// @opacity = 0.6
		// @spriteOpacity = 0.5
	},
	
	__set@isTarget = function(value){
		@_isTarget === value && return;
		@_isTarget = value
		@resAnim = res.get(value ? "slot-target" : "slot")
		@size = vec2(SLOT_SIZE, SLOT_SIZE)
	},
}