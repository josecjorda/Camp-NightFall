extends Node2D

@onready var progress = 0
@onready var phase = 0

@onready var you = get_node("Actors/You")
@onready var ethan = get_node("Actors/Ethan")
@onready var monster = get_node("Actors/Monster")
@onready var swimSound = get_node("SwimSound")

@onready var dx = abs(ethan.position.x - you.position.x)
@onready var dy = abs(ethan.position.y - you.position.y)
@onready var monsterSpeed = Vector2(0,0)

func _ready():
	pass 
	
func _process(delta):
	monster.position += monsterSpeed * delta
	pass

func _on_slider_minigame_hit_timing_target():
	if phase != 2:
		var step = 25
		if phase == 1:
			step *= -1
		progress += step
		you.position.x += float(dx*step/100)
		you.position.y -= float(dy*step/100)
		swimSound.pitch_scale = 1 + randf_range(-.05,.02)
		swimSound.play()
		print(progress)
		if progress >= 100 && phase == 0:
			phase = 1
			ethan.visible = false
			you.flip_h = true
			you.position.x = ethan.position.x
			progress = 100
			
			monster.position.x = ethan.position.x  + 100
			monster.position.y = ethan.position.y 
			monsterSpeed = Vector2(-50,0)
		
		if progress <= 0 && phase == 1:
			declareVictory()
			phase = 2

func declareVictory():
	get_node("Victory").play()
	get_node("VictoryScreen").visible = true

func die():
	pass
	
func _on_slider_minigame_missed_timing_target():
	var step = -5
	if phase == 1:
		step *= -1
	progress += step
	you.position.x += float(dx*step/100)
	you.position.y -= float(dy*step/100)
	print(progress)
