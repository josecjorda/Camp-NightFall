extends Panel
## Describes the underlying logic of how the inventory slots are displayed
##
## [b]Notes:[/b][br]
## - when the update function is called it makes the passed in item visible for the user.

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display

func update(slot: InvSlot):
	if !slot.item:
		item_visual.visible = false
	else:
		item_visual.visible = true
		item_visual.texture = slot.item.texture
