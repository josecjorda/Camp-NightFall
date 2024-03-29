extends StaticBody2D

@export var item: InvItem
var player = null


func _on_interactable_area_body_entered(body):
	if body.has_method("player"):
		player = body
		Global.invArr.append("Knife")
		playercollect()
		self.queue_free()

func playercollect():
	player.collect(item)
