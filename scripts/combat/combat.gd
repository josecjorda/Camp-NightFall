extends Control

## Boss class. Didn't make a resource script just because we only have one enemy.
class boss_class:
	var max_health = 1000
	var health = max_health
	var damage = 50
	var attacks = { ## Index of damage arrays will correlate with dice rolls
		"spectral_scream": {
			"damage" : null,
			"debuff" : {"name" : "fear", "turns" : 2, "roll_disadvantage" : 2}
		},
		"revenant_rip": {
			"damage" : [0, 0, 0, 0, 6, 7, 8, 9],
			"debuff" : null
		},
		"ghast_blast": {
			"damage" : [0, 0, 2, 3, 3, 4, 4, 4],
			"debuff" : {"name" : "poison", "turns": 4, "dot": 5}
		}
	}
	
var enemy = boss_class.new()

func _ready():
	$TextBox.hide()
	set_health($EnemyHealthBar, enemy.health, enemy.max_health)
	set_health($PlayerHealthBar, Global.player_health, Global.player_max_health)
	display_text("RIP")


## Closes text box when input is received
func _input(event):
	# Closes textbox
	if ((Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible):
		$TextBox.hide()


## Sets health of an entity
func set_health(progress_bar, health, max_health):
	progress_bar.max_value = max_health
	progress_bar.value = health
	progress_bar.get_node("Label").text = "HP:%d/%d"%[health,max_health]

## Displays text box
func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text
