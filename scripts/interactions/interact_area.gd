extends Area2D

class_name Interactable

@export var interact_label = "none"
@export var interact_type = "none"
@export var interact_value = "none"

var player_in_area = false

#func _process(delta):
	#if player_in_area:
		#if Input.is_action_just_pressed("f"):
			
