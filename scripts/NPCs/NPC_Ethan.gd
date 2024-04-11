##########################################################################
## Notes / Things to do:
## Still need to adjust the path on how Anna goes out of the building 
## Dialogue to be added not sure if Kierra wants to put that herself or I will
## Transition to the minigame scene
## Ask Benjamin is there a losing condition on minigame

extends CharacterBody2D



var player_is_near = false
var move = false

var direction = Vector2.ZERO
var speed = 200

func _ready():
	$AnimatedSprite2D.play("drowning")


func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player_is_near = true

func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		player_is_near = false

func _unhandled_input(event):
	if player_is_near and event.is_action_pressed("interact"):
		if "Rope" in Global.invArr:
			move = true
			await get_tree().create_timer(2.0).timeout
			self.queue_free() # make Ethan disappear
			Global.kids_saved[2] = 1 # store Ethan as a saved kid in the global array
		else:
			go_to_ethan_minigame()
			print("ethan minigame works") # testing
			

func _physics_process(delta):
	if move:
		$AnimatedSprite2D.play("backwards")
		direction = Vector2.UP.normalized()
		velocity = (direction * speed)
		move_and_slide()
		await get_tree().create_timer(2.0).timeout

func go_to_ethan_minigame():
	# change this to the path of the minigame scene
	#var next_scene = "res://scenes/combat/combat.tscn"
	#get_tree().change_scene_to_file(next_scene)
	pass
