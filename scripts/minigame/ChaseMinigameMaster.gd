extends Node2D

@onready var progress = 0
@onready var phase = 0

func _ready():
	pass 
	
func _process(delta):
	pass

func _on_slider_minigame_hit_timing_target():
	progress += 1
	print(progress)

func _on_slider_minigame_missed_timing_target():
	progress -= 1
	print(progress)
