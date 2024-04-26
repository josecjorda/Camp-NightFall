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
		#Global.invArr.append(item.name)
	if item.name == 'lighter':
		Global.lighters = true
	if item.name == 'rope':
		Global.rope_bait = true
	if item.name == 'boltcutters':
		Global.bolt_cutters = true
	if item.name == 'axe':
		Global.axe = true
	if item.name == ' knife':
		Global.knife = true
	if item.name == ' machete':
		Global.machete = true
	if item.name =='bandages':
		Global.bandages = true
	update.emit()


