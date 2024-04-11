extends CharacterBody2D


# speed in pixels/sec
@export var speed = 350

@onready var _animated_sprite = $AnimatedSprite2D 
@export var inv: Inv

# characteristics
var playerName = Global.playerName
var gender = Global.gender
var hair = Global.hair
var prefix = gender + "-" + hair + "-"



func _ready():
	$saved_kids_indicator/Anna_indicator.visible = false
	$saved_kids_indicator/Ethan_indicator.visible = false
	$AnimatedSprite2D.animation = prefix + "Run-Right-Animation"
	
func get_input():
# setup direction of movement
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
# stop diagonal movement by listening for input then setting axis to zero
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
	if Global.kids_saved[0] == 1:
		$saved_kids_indicator/Anna_indicator.visible = true
	if Global.kids_saved[2] == 1:
		$saved_kids_indicator/Ethan_indicator.visible = true
	
	




# Interaction methods
########################################################################
	
func player():
	pass

func collect(item):
	inv.insert(item)


