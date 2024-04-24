extends StaticBody2D
## Describes how the "lighter" item is picked up by the player
##
## [b]Notes:[/b][br]
## - calls the global variable invArr to store that this item is picked up by the user to later
## be passed on to the final boss fight and possible as determinates for saving the kid NPCs.

@export var item: InvItem
var player = null


func _on_interactable_area_body_entered(body):
	if body.has_method("player"):
		player = body
		Global.invArr.append("Lighter")
		playercollect()
		self.queue_free()

func playercollect():
	player.collect(item)
