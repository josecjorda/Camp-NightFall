extends CharacterBody2D
## A NPC character named Anna which the user can choose to save by following a condition
##
## [b]Rules:[/b][br]
## - Anna can only be interacted with once the player is within Anna's collision range[br]
## - The saving condition for Anna is to have a "sharp object" such as boltcutters, machete, knife, or axe[br]

# Notes:
# Still need to adjust the path on how Anna goes out of the building 
# Dialogue to be added not sure if Kierra wants to put that herself or I will

## boolean to determine if the player is within the NPC's collision box
var player_is_near = false
## boolean to determine how the pathing will work for the NPC to leave the map
var move = false
## boolean to manage NPC dialouge
var interaction_finished = false

## variables to determine speed and direction of the NPC's path
var direction = Vector2.ZERO
var speed = 200

func _ready():
	$AnimatedSprite2D.play("crying_on_ground")

## if the player is within the NPC's collision box
func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		$Label.text = "Counselor! Please I'm stuck could you cut the bed frame out?!"
		player_is_near = true

## if the player is out of the NPC's collision box
func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		$Label.text = ""
		player_is_near = false

func _unhandled_input(event):
	if player_is_near and event.is_action_pressed("interact"): ## is the player in the collision box and has the "f" key been pressed
		if "Boltcutters" in Global.invArr or "knife" in Global.invArr or "Machete" in Global.invArr or "Axe" in Global.invArr:
			# play getting up animation
			interaction_finished = true
			$Label.text = "Thank you so much Counselor!"
			$AnimatedSprite2D.play("getting_up")
			await get_tree().create_timer(4.0).timeout
			$AnimatedSprite2D.stop()
			###########################################################
			## 1. also need the movement where she gets up out of there
			move = true
			await get_tree().create_timer(3.0).timeout
			## 2. add await() timer as well after each movement
			self.queue_free() # make Anna disappear
			Global.kids_saved[0] = 1 # store Anna as a saved kid in the global array
			
func _physics_process(delta):
	# WORK ON THIS MOVEMENT MORE WHEN BUILDINGS ARE OUT
	if move: ## performs the pathing to move off of the map
		$AnimatedSprite2D.play("forwards")
		direction = Vector2.DOWN.normalized()
		velocity = (direction * speed)
		move_and_slide()
		await get_tree().create_timer(3.0).timeout
		
		#$AnimatedSprite2D.stop()
		#velocity = Vector2.ZERO
		#
		#$AnimatedSprite2D.play("left")
		#direction = Vector2.LEFT.normalized()
		#velocity = (direction * speed)
		#await get_tree().create_timer(1.0).timeout
		
func _process(delta):
	if player_is_near == false and interaction_finished == false:
		$Label.text = "HELP ME!!! IT HURTS!!!"
		
		
