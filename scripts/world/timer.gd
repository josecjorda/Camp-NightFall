extends Node2D

## Changes rotation of needle on clock asset based on time and checks if it's time to fight.
## Time is saved in minutes.

var end_time = 3 ## Time to switch to combat
func _process(delta):
	var time = Global.elapsed_time
	$clock_hand.rotation_degrees = 360/end_time * time
	if time >= end_time:
		go_to_combat()


## When time runs out go to boss fight
func go_to_combat():
	var next_scene = "res://scenes/combat/combat.tscn"
	get_tree().change_scene_to_file(next_scene)
