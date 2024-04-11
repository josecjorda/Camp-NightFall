##########################################################################
## Notes:
## Still need to adjust the path on how Anna goes out of the building 
## Dialogue to be added not sure if Kierra wants to put that herself or I will

extends CharacterBody2D



var player_is_near = false
var move = false

var direction = Vector2.ZERO
var speed = 200

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
		if "Boltcutters" in Global.invArr or "knife" in Global.invArr or "Machete" in Global.invArr or "Axe" in Global.invArr:
			# play getting up animation
			$AnimatedSprite2D.play("getting_up")
			await get_tree().create_timer(4.0).timeout
			$AnimatedSprite2D.stop()
			###########################################################
			## 1. also need the movement where she gets up out of there
			move = true
			await get_tree().create_timer(2.0).timeout
			## 2. add await() timer as well after each movement
			self.queue_free() # make Anna disappear
			Global.kids_saved[0] = 1 # store Anna as a saved kid in the global array
			
func _physics_process(delta):
	##### WORK ON THIS MOVEMENT MORE WHEN BUILDINGS ARE OUT
	if move:
		$AnimatedSprite2D.play("forwards")
		direction = Vector2.DOWN.normalized()
		velocity = (direction * speed)
		move_and_slide()
		await get_tree().create_timer(2.0).timeout
		
		#$AnimatedSprite2D.stop()
		#velocity = Vector2.ZERO
		#
		#$AnimatedSprite2D.play("left")
		#direction = Vector2.LEFT.normalized()
		#velocity = (direction * speed)
		#await get_tree().create_timer(1.0).timeout
		
		
