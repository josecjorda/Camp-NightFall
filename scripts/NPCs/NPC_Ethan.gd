extends CharacterBody2D
## A NPC character named Ethan which the user can choose to save by following certain conditions
##
## [b]Rules:[/b][br]
## - Ethan can only be interacted with once the player is within Ethan's collision range[br]
## - If the player does not have the required item to save Ethan, the player will be transitioned
## to a minigame scene where the player must run away from the monster in order to save Ethan.[br]
##
## [b]Notes:[/b][br]
## - Ethan has multiple saving conditions either by having the required item or beating the minigame.[br]
## - The global variable that saves if a kid has been saved must be altered in the minigame script in
## order to finish phases in this script.

# Things to do:
# Still need to adjust the path on how Anna goes out of the building 
# Dialogue to be added not sure if Kierra wants to put that herself or I will
# Transition to the minigame scene
# Ask Benjamin is there a losing condition on minigame

## boolean to determine if the player is within the NPC's collision box
var player_is_near = false
## boolean to determine how the pathing will work for the NPC to leave the map
var move = false

## variables to determine speed and direction of the NPC's path
var direction = Vector2.ZERO
var speed = 200

func _ready():
	$AnimatedSprite2D.play("drowning")

## if the player is within the NPC's collision box
func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		$Label.text = "ARaghauf... I...CAN'T...SWIM!!!"
		player_is_near = true

## if the player is out of the NPC's collision box
func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		$Label.text = ""
		player_is_near = false

func _unhandled_input(event):
	if player_is_near and event.is_action_pressed("interact"): ## is the player in the collision box and has the "f" key been pressed
		if "Rope" in Global.invArr: ## does the player have the "Rope" item
			$Label.text = "Thank you so much Counselor!"
			move = true
			await get_tree().create_timer(2.0).timeout
			self.queue_free() # make Ethan disappear
			Global.kids_saved[2] = 1 # store Ethan as a saved kid in the global array
		else: ## transition to minigame if the player does not have the "Rope" item
			#get_tree().paused = true # pauses the state of the Overworld Scene
			go_to_ethan_minigame()
			print("ethan minigame works") # testing
			if Global.kids_saved[2] == 0: # if Ethan was not saved in the minigame
				self.queue_free()
			elif Global.kids_saved[2] == 1: # if Ethan was saved in the minigame
				pass
				#move = true
			

func _physics_process(delta):
	if move: ## performs the pathing to move off of the map
		$AnimatedSprite2D.play("backwards")
		direction = Vector2.UP.normalized()
		velocity = (direction * speed)
		move_and_slide()
		await get_tree().create_timer(2.0).timeout

## performs the scene transition to the Ethan saving minigame
func go_to_ethan_minigame():
	# change this to the path of the minigame scene
	#var next_scene = "res://scenes/combat/combat.tscn"
	#get_tree().change_scene_to_file(next_scene) # switches over to the minigame scene
	pass
