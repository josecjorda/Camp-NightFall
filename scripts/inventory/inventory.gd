extends Resource
## This descibes how each individual inventory slot gets updated as items are picked up
##
## [b]Rules:[/b][br]
## - updates the inventory slots when items are picked up.[br]

class_name Inv

signal update

@export var slots: Array[InvSlot]

## inserts the item into the next available inventory slot
func insert(item: InvItem):
	var emptyslots = slots.filter(func(slot): return slot.item == null)
	if !emptyslots.is_empty():
		emptyslots[0].item = item
		#emptyslots[0].amount = 1
	update.emit()


