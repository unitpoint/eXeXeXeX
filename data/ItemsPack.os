ItemsPack = extends Object {
	__object = {
		items = {}, // by slot num
		numItemsByType = {},
	},
	
	updateNumItems = function(){
		@numItemsByType = {}
		for(var _, item in @items){
			var count = @numItemsByType[item.type] || 0
			@numItemsByType[item.type] = count + item.count
		}
	},
	
	updateActorItems = function(actor, startSlotNum, count){
		@updateNumItems()
		for(var _, slot in actor.slots){
			slot.clearItem()
		}
		startSlotNum || startSlotNum = 0
		count || count = #actor.slots
		var endSlotNum = startSlotNum + count
		for(var slotNum = startSlotNum; slotNum < endSlotNum; slotNum++){
		// for(var slotNum, item in @items){
			var item = @items[slotNum] || continue
			var slot = actor.slots[slotNum] || continue
			slot.type = item.type
			slot.count = item.count
		}
	},
}