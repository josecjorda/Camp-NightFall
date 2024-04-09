extends CharacterBody2D



var player = null
var player_is_near = false

func _ready():
	$AnimatedSprite2D.play("crying_on_ground")


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player_is_near = true

func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		player_is_near = false

func _unhandled_input(event):
	if player_is_near and event.is_action_pressed("interact"):
		if "Boltcutters" in Global.invArr or "Knife" in Global.invArr or "Machete" in Global.invArr or "Axe" in Global.invArr:
			# play getting up animation
			$AnimatedSprite2D.play("getting_up")
			##### also need the movement where she gets up out of there
			await get_tree().create_timer(4.0).timeout
			self.queue_free()
			
	
