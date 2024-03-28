extends Control
## Combat stuff
## dots activate at beginning of a entitiy's turn

## Boss class. Didn't make a resource script just because we only have one enemy.
class boss_class:
	var name = "Enemy"
	var health_name = "Enemy" ## Correlates to health bar name
	var max_health = 1000
	var health = max_health
	var buffs = []
	var debuffs = []
	var actions = { ## Index of damage and effect arrays will correlate with dice rolls
		"spectral_scream": {
			"damage" : null,
			"effect" : null,
			"heal" : null,
			"debuff" : {"name" : "fear", "turns" : 2, "roll_disadvantage" : 2},
			"buff" : null,
			"cleanse" : null
		},
		"revenant_rip": {
			"damage" : [0, 0, 0, 0, 6, 7, 8, 9],
			"effect" : null,
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null
		},
		"ghast_blast": {
			"damage" : [0, 0, 2, 3, 3, 4, 4, 4],
			"effect" : null,
			"heal" : null,
			"debuff" : {"name" : "poison", "turns": 4, "dot": 5},
			"buff" : null,
			"cleanse" : null
		}
	}
## Player class
class player_class:
	var name = Global.playerName
	var health_name = "Player" ## Correlates to health bar name
	var max_health = Global.player_max_health
	var health = Global.player_health
	var buffs = []
	var debuffs = []
	var actions = { ## Index of damage and effect arrays will correlate with dice rolls
		"Fist": {
			"damage" : [0, 0, 1, 1, 1, 1, 2, 2],
			"effect" : ["Break", "Break", "Nothing", "Nothing", "Nothing", "Nothing", "Nothing", "Double Damage"],
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null
		},
		"Axe": {
			"damage" : [0, 0, 0, 6, 6, 7, 8, 9],
			"effect" : ["Break", "Break", "Break", "Nothing", "Nothing", "Nothing", "Nothing", "Double Damage"],
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null
		},
		"Shotgun": {
			"damage" : [0, 0, 9, 9, 9, 10, 10, 11],
			"effect" : null,
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null
		},
		"Machete": {
			"damage" : [0, 0, 3, 3, 4, 4, 4, 5],
			"effect" : ["Break", "Break", "Nothing", "Nothing", "Nothing", "Nothing", "Nothing", "Double Damage"],
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null
		},
		"knife": {
			"damage" : [0, 0, 3, 3, 3, 3, 4, 4],
			"effect" : ["Break", "Break", "Nothing", "Nothing", "Nothing", "Nothing", "Nothing", "Double Damage"],
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null
		},
		"Boltcutters": {
			"damage" : [0, 0, 3, 3, 3, 3, 4, 4],
			"effect" : ["Break", "Break", "Nothing", "Nothing", "Nothing", "Nothing", "Nothing", "Double Damage"],
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null
		},
		"Soda": {
			"damage" : null,
			"effect" : null,
			"heal" : 1.0/5.0,
			"debuff" : null,
			"buff" : null,
			"cleanse" : "poison"
		},
		"Crackers": {
			"damage" : null,
			"effect" : null,
			"heal" : 3.0/5.0,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null
		},
		"Bandages": {
			"damage" : null,
			"effect" : null,
			"heal" : 1.0,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null
		},
		"Alcohol": {
			"damage" : null,
			"effect" : null,
			"heal" : null,
			"debuff" : null,
			"buff" : {"name" : "alcohol", "turns": 1, "damage_increase": 1},
			"cleanse" : "fear"
		},
		"Chocolate": {
			"damage" : null,
			"effect" : null,
			"heal" : 2.0/5.0,
			"debuff" : null,
			"buff" : {"name" : "chocolate bar", "turns": 1, "break_roll_increase": 1},
			"cleanse" : null
		}
		
	}


## Enemy object
var enemy = boss_class.new() 
var player = player_class.new()
## Array of items in inventory
var item_bar = ["Fist", "Axe", "Shotgun", "Machete", "knife", "Boltcutters", "Soda", "Crackers", "Bandages", "Alcohol", "Chocolate"]
var consumables = ["Soda", "Crackers", "Bandages", "Alcohol", "Chocolate"]
func _ready():
	hide_text()
	set_health($EnemyHealthBar, enemy.health, enemy.max_health)
	set_health($PlayerHealthBar, player.health, player.max_health)
	var item_buttons = $Itembar/HBoxContainer.get_children() 
	for index in range(item_bar.size()): ## Connects buttons to signal and adds textures based on inventory
		var button = item_buttons[index]
		var item = item_bar[index]
		button.set_name(item)
		button.pressed.connect(player_action_choice.bind(item))
		var image_path = "res://graphics/items/" + item + ".png"
		var image = load(image_path)
		button.texture_normal = image


## Closes text box when input is received
func _input(event):
	# Closes textbox
	if ((Input.is_action_just_released("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $TextBox.visible):
		hide_text()


## Sets health of an entity
func set_health(progress_bar, health, max_health):
	progress_bar.max_value = max_health
	progress_bar.value = health
	progress_bar.get_node("Label").text = "HP:%d/%d"%[health,max_health]


## Displays text box
func display_text(text):
	if $TextBox.is_visible() == false:
		$TextBox.show()
	$TextBox/Label.text += text


## Hides text box and deletes text
func hide_text():
	$TextBox.hide()
	$TextBox/Label.text = ""


## Player chooses item then moves to enemy action
func player_action_choice(action_name):
	var action = player.actions.get(action_name)
	if action_name in consumables:
		action(player, player, action, action_name)
	else:
		action(player, enemy, action, action_name)
	enemy_action_choice()
	proc_dots(enemy)

## Chooses enemy action
func enemy_action_choice():
	var action_name = roll(enemy.actions.keys())
	var action = enemy.actions.get(action_name)
	display_text("Enemy used " + action_name + ". ")
	action(enemy, player, action, action_name)
	proc_dots(player)

# Rolls dice to see action effects
func roll(roll_values):
	return roll_values[randi()%roll_values.size()]


## Activates damage over time debuffs
func proc_dots(target):
	var debuffs = target.debuffs
	for dict in debuffs:
		if "dot" in dict:
			target.health -= dict.dot 
			dict.turns -= 1
			print(dict.name + " activated on " + target.health_name)

## Damages target by set amount until 0 hp reached.
func damage(target, amount):
	if target.health - amount <= 0:
		target.health = 0
	else: 
		target.health -= amount
	var target_health_bar = get_node(target.health_name + "HealthBar")
	set_health(target_health_bar, target.health, target.max_health)


## Heals target by a set amount. Capped at targets maxed hp.
func heal(target, amount, action_name):
	if target.health + amount >= target.max_health:
		target.health = target.max_health
	else: 
		target.health += amount
	var target_health_bar = get_node(target.health_name + "HealthBar")
	set_health(target_health_bar, target.health, target.max_health)


## Checks 2d array of dictionaries for a debuff or buff name.
func not_in_arr(name, arr):
	for dict in arr:
		if name == dict.name:
			return false
	return true

## Removes item from item bar by turning it invisible
func remove_item(action_name):
	var item = $Itembar/HBoxContainer.get_node(action_name)
	item.visible = false

## Applys effects from action and activates effects already on target such as debuffs, dots, buffs, etc.
func action(source, target, action_info, action_name):
	if action_info.damage != null:
		var damage = roll(action_info.damage)
		if action_info.effect != null:
			var effect = roll(action_info.effect)
			if effect == "Double Damage":
				damage *= 2
			elif effect == "Break":
				remove_item(action_name)
		damage(target, damage)
		display_text("Dealt " + str(damage) + " damage. ")
	if action_info.heal != null:
		var heal = action_info.heal * target.max_health
		heal(target, heal, action_name)
		display_text("Healed " + str(heal) + " health. ")
	if action_info.debuff != null:
		if not_in_arr(action_info.debuff.name, target.debuffs):
			target.debuffs.append(action_info.debuff)
		display_text("Applied " + action_info.debuff.name + ". ")
	if action_info.buff != null:
		if not_in_arr(action_info.buff.name, target.buffs):
			target.buffs.append(action_info.buff)
		display_text("Applied " + action_info.buff.name + ". ")
		
	if action_name in consumables: ## Removes player consumables after used
		remove_item(action_name)
