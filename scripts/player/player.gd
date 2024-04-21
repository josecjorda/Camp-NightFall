extends CharacterBody2D
## Describes overall player movement that the user has control over
##
## [b]Rules:[/b][br]
## - The user will be able to control the player with the keys 'w' (UP), 'a' (LEFT), 's' (DOWN), and 'd' (RIGHT).[br]
##
## [b]Notes:[/b][br]
## - The approriate animation loop will play depending on which direction the player is moving.[br]
## - Passes items that are picked up to the appropriate inventory scripts that will handle that.[br]
## - Calls the global script whenever a child is saved in order to display an indicator on the UI.[br]

# speed in pixels/sec
@export var speed = 350

@onready var _animated_sprite = $AnimatedSprite2D 
## inventory variable needed for the inventory scripts to later handle
@export var inv: Inv

## characteristics variables
var playerName = Global.playerName
var gender = Global.gender
var hair = Global.hair
var prefix = gender + "-" + hair + "-"



func _ready():
	$saved_kids_indicator/Anna_indicator.visible = false
	$saved_kids_indicator/Ethan_indicator.visible = false
	$saved_kids_indicator/Beth_indicator.visible = false
	$AnimatedSprite2D.animation = prefix + "Run-Right-Animation"
	
func get_input():
# setup direction of movement
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
# stop diagonal movement by listening for input then setting axis to zero
	## performs the appropriate animation depending on the direction of the player
	if Input.is_action_pressed("ui_right"):
		_animated_sprite.play(prefix + "Run-Right-Animation")
		direction.y = 0
	elif Input.is_action_pressed("ui_left"):
		_animated_sprite.play(prefix + "Run-Left-Animation")
		direction.y = 0
	elif Input.is_action_pressed("ui_up"):
		_animated_sprite.play(prefix + "Run-Backward-Animation")
		direction.x = 0
	elif Input.is_action_pressed("ui_down"):
		_animated_sprite.play(prefix + "Run-Forward-Animation")
		direction.x = 0
	else:
		_animated_sprite.stop()
		direction = Vector2.ZERO


#normalize the directional movement
	direction = direction.normalized()
# setup the actual movement
	velocity = (direction * speed)
	
	

func _physics_process(delta):
	get_input()
	move_and_slide()
	
func _process(delta):
	## constantly checks for when a kid is saved to display indicator on UI
	if Global.kids_saved[0] == 1:
		$saved_kids_indicator/Anna_indicator.visible = true
	if Global.kids_saved[1] == 1:
		$saved_kids_indicator/Beth_indicator.visible = true
	if Global.kids_saved[2] == 1:
		$saved_kids_indicator/Ethan_indicator.visible = true

	if velocity.x != 0 or velocity.y != 0:
		if !$audio_components/footsteps.playing:
			$audio_components/footsteps.pitch_scale = 1.75
			$audio_components/footsteps.play()
	elif $audio_components/footsteps.playing:
		$audio_components/footsteps.stop()


# Interaction methods
########################################################################
	
func player():
	pass

## collection function to be passed on to the inventory scripts to handle
func collect(item): 
	inv.insert(item)
	$audio_components/pick_up_item.play()
	await get_tree().create_timer(1.0).timeout
	$audio_components/pick_up_item.stop()


