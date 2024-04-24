extends Node2D

@onready var progress = 0
enum gamePhases{
	SWIMMING_TO_ETHAN = 0,
	SWIMMING_TO_DOCK = 1,
	DEAD = 2,
	WON = 3
}
@onready var phase:gamePhases = 0
@onready var you = get_node("Actors/You")
@onready var ethan = get_node("Actors/Ethan")
@onready var monster = get_node("Actors/Monster")
@onready var swimSound = get_node("SwimSound")
@onready var dx = abs(ethan.position.x - you.position.x)
@onready var dy = abs(ethan.position.y - you.position.y)
@onready var monsterSpeed = Vector2(0,0)

const punishStep = -4
const rewardStep = 3

@onready var combo = 0

func _ready():
	pass 
	
func _process(delta):
	monster.position += monsterSpeed * delta
	if(monster.position.x < you.position.x && phase < 2):
		die()
	pass

func _on_slider_minigame_hit_timing_target():
	if phase < 2:
		var step = rewardStep + combo
		if phase == 1:
			step *= -1
		progress += step
		moveYou(step)
		combo+=1
		playRandomSwimSound()
		if progress >= 100 && phase == 0:
			phase = 1
			progress = 100
			combo = 0
			ethan.visible = false
			you.flip_h = true
			you.position.x = ethan.position.x
			startMonster()
		if progress <= 0 && phase == 1:
			declareVictory()

func moveYou(step):
	you.position.x += float(dx*step/100)
	you.position.y -= float(dy*step/100)
	
func playRandomSwimSound():
	swimSound.pitch_scale = 1 + randf_range(-.05,.02)
	swimSound.play()

func startMonster():
	monster.position.x = 1232
	monster.position.y = ethan.position.y 
	monsterSpeed = Vector2(-60,0)
	
func declareVictory():
	phase = 3
	get_node("Victory").play()
	get_node("VictoryScreen").visible = true

func die():
	phase = 2
	get_node("Augh").play()
	get_node("DieScreen").visible = true
	get_node("RestartTimer").start()
	
func _on_restart_timer_timeout():
	get_node("RestartTimer").stop()
	restart()
	
func restart():
	progress = 0
	ethan.visible = true
	you.flip_h = false
	you.position.x = ethan.position.x - dx
	monster.position.x = 2000
	get_node("DieScreen").visible = false
	monsterSpeed = Vector2(0,0)
	phase = 0
	
func _on_slider_minigame_missed_timing_target():
	if phase < 2:
		var step = punishStep
		if phase == 1:
			step *= -1
		progress += step
		moveYou(step)
		combo = 0
		get_node("Blow").play()


