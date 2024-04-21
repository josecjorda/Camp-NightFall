extends CharacterBody2D
## A NPC character named Beth which the user can choose to save by following certain conditions
##
## [b]Rules:[/b][br]
## - Beth can only be interacted with once the player is within Beth's collision range.[br]
## - If the player does not have the required items to save Beth, the game will perform the "wrong"
## condition which will unfortunely not save Beth.[br]
## - Beth will have different movement paths depending on the condition that were met.[br]
##
## [b]Notes:[/b][br]
## - Beth requires for the player to have 2 specific items at the same time to save.[br]
## - The global variable that saves if a kid has been saved must be altered in the minigame script in
## order to finish phases in this script.

## boolean to determine if the player is within the NPC's collision box
var player_is_near = false
## boolean to determine how the pathing will work for the NPC to leave the map
var move = false
## boolean to determine actions based on if Beth's wound gets cauterized
var cauterize_wound = false
## boolean to manage NPC dialouge
var interaction_finished = false

## variables to determine speed and direction of the NPC's path
var direction = Vector2.ZERO
var speed = 200

func _ready():
	$Sprite2D.visible = true

## if the player is within the NPC's collision box
func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		$Label.text = "Counselor! My foot is bleeding! Can you help me!?!?"
		player_is_near = true

## if the player is out of the NPC's collision box
func _on_area_2d_body_exited(body):
	if body.has_method("player"):
		$Label.text = ""
		player_is_near = false

func _unhandled_input(event):
	if player_is_near and event.is_action_pressed("interact"): ## is the player in the collision box and has the "f" key been pressed
		if "Bandages" in Global.invArr and "Lighter" in Global.invArr: ## does the player have the "Bandages" or "Lighter" item
			interaction_finished = true
			$Sprite2D.visible = false
			$AnimatedSprite2D.play("getting_up_bandaged")
			$Label.text = "It still hurts really bad, but I think I can at least make it out to safety."
			await get_tree().create_timer(3.0).timeout
			move = true
			cauterize_wound = true
			await get_tree().create_timer(3.0).timeout
			self.queue_free()
			Global.kids_saved[1] = 1
		else: ## perform the "wrong" condition if player doesn't have "Bandages" item
			interaction_finished = true
			$Sprite2D.visible = false
			$AnimatedSprite2D.play("getting_up")
			$Label.text = "I'll just have to hide in the kitchen... I can't stay here..."
			await get_tree().create_timer(3.0).timeout
			move = true
			cauterize_wound = false
			await get_tree().create_timer(15.0).timeout
			self.queue_free()
			Global.kids_saved[1] = 0

func _physics_process(delta):
	if move and cauterize_wound: ## performs the pathing to move off of the map with bandages
		direction = Vector2.DOWN.normalized()
		velocity = (direction * speed)
		$AnimatedSprite2D.play("forwards_bandaged")
		move_and_slide()
		await get_tree().create_timer(3.0).timeout
	elif move and !cauterize_wound: ## performs pathing without bandages
		speed = 75
		direction = Vector2.LEFT.normalized()
		velocity = (direction * speed)
		$AnimatedSprite2D.play("left")
		move_and_slide()
		await get_tree().create_timer(15.0).timeout
		
func _process(delta):
	if player_is_near == false and interaction_finished == false:
		$Label.text = "AUOOCH IT HURTS!!! MY FOOT!!!"
