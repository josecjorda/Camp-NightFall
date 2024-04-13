extends Control
## The overall inventory UI that displays at the bottom of the user's screen
##
## [b]Rules:[/b][br]
## - Updates the inventory slots whenever an item is picked up.[br]
## - Allows user to hide the inventory by pressing 'i' as needed.[br]
##
## [b]Notes:[/b][br]
## - Requires information that is passed from either the player and/or inv_ui_slot scripts

## variables for inventory design
@onready var inv: Inv = preload("res://scripts/inventory/playerinv_res/playerinv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var is_open = false

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	open()
	
func update_slots():
	for i in range(min(inv.slots.size(), slots.size())): ## makes sure items are updated in sequential order
		slots[i].update(inv.slots[i])

func _process(delta):
	if Input.is_action_just_pressed("i"): ## checks if the 'i' key was pressed
		if is_open:
			close()
		else:
			open()

func open(): ## makes the inventory UI visible
	self.visible = true
	is_open = true

func close(): ## makes the inventory UI not visible
	visible = false
	is_open = false
