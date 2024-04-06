extends Control
## An implementation of a turn based combat system. Very DnD esc combat system, 
## where each weapon has their own damage troika table and a die for breaking.
##
## [b]Combat flow[/b]:[br]
## - Turns are determined by the player_turn variable. When a textbox is clicked and removed it switches turns.
## in the _input function. If its the player turn, they have to click an item in the item bar which moves to player_action choice
## If its enemeies turn then _input automatically moves to enemy_action_choice. Both functions will take an action and
## call the action function for processing.[br]
##
## [b]Rules:[/b][br]
## - Can only do 1 thing per turn (attack or use item)
## - When the weapon is used, the Break Die is rolled and if lands on effect break, the weapon breaks and can no longer be used (disappears from the item bar). 
## - Each Troika roll is a D8
## - Dice rolls effect outcome of damage and action effects
## - Dots activate at beginning of a entitiy's turn[br]
## - Enemy action is chosen based off moves that aren't on cooldown. Moves that are off cooldown are randomly selected.[br]
##
## [b]Notes:[/b][br]
## - Different object classes are imported from entities.gd
## - Code is written so only player has buffs and debuffs. if wanting to add them to enemy, 
## will have to change some code. Some of the codes assumes target is player/enemy so probably 
## will have to be more exact.[br]
## - Code could use some cleaning up as something aren't very intuitive. Such as buff/debuff removal code being 
## repeated in different functions instead of being its own function.
## - Could maybe incentivize player to use weaker items by adding a buff for each item broken

var entities = preload("res://scripts/combat/entities.gd")


## Enemy object
var enemy = entities.monster_class.new() 
var player = entities.player_class.new()
## Array of items in inventory
#var item_bar = ["Fist", "Axe", "test", "Shotgun", "Machete", "knife", "Boltcutters", "Soda", "Crackers", "Bandages", "Alcohol", "Chocolate"]
var item_bar = Global.invArr
var consumables = ["Soda", "Crackers", "Bandages", "Alcohol", "Chocolate"]
var player_turn = true


func _ready():
	if "Fist" not in item_bar:
		item_bar.append("Fist") # Adds fist to inventory
	$Enemy.play("default")
	$Player.play(Global.gender + "_"+ "default")
	hide_text()
	$PlayerName.text = player.name
	set_health($EnemyHealthBar, enemy.health, enemy.max_health)
	set_health($PlayerHealthBar, player.health, player.max_health)
	var item_buttons = $Itembar/HBoxContainer.get_children() 
	for item in item_bar: ## Removes unusuable items from item_bar
		if item not in player.actions.keys():
			item_bar.erase(item)
	for index in range(item_bar.size()): ## Connects buttons to signal and adds textures based on inventory
		var button = item_buttons[index]
		var item = item_bar[index]
		button.set_name(item)
		button.pressed.connect(player_action_choice.bind(item))
		var image_path = "res://graphics/items/" + item + ".png"
		var image = load(image_path)
		button.texture_normal = image
		button.tooltip_text = player.actions.get(item).get("tool_tip")


## Looks for input. Is used as a way to close textboxes and switch between player and enemy turn.
func _input(event):
	## Closes textbox and goes to enemy turn if was players turn
	var event_text = event.as_text()
	if ((Input.is_action_just_released("ui_accept") or (event is InputEventMouseButton and event.button_index == 1 and event.pressed == false)) and $TextBox.visible):
		hide_text()
		if player_turn:
			player_turn = false
			enemy_action_choice()
		elif not player_turn:
			player_turn = true


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
	proc_dots(enemy)

## Chooses enemy action
func enemy_action_choice():
	var possible_actions = enemy.actions.keys()
	for action in possible_actions: ## Removes actions on cooldown and adds a turn to last used
		if "debuff" in enemy.actions.get(action):
			if enemy.actions.get(action).last_used < enemy.actions.get(action).cool_down:
				possible_actions.erase(action)
	for action in enemy.actions:
		enemy.actions.get(action).last_used +=1
	var action_name = possible_actions[randi()%possible_actions.size()]
	var action = enemy.actions.get(action_name)
	action.last_used = 0
	action(enemy, player, action, action_name)
	proc_dots(player)


## Rolls dice to choose damage amount
func roll(source, roll_values):
	var roll = randi()%roll_values.size()
	for debuff in source.debuffs:
		if "roll_decrease" in debuff:
			roll -= debuff.roll_decrease
			debuff.turns -= 1
			var debuff_icon = get_node("StatusBar/" + debuff.name)
			debuff_icon.tooltip_text = ""
			for key in debuff.keys():
				debuff_icon.tooltip_text += key + ": " +  str(debuff[key]) + "\n"
			if debuff.turns == 0:
				debuff_icon.queue_free()
				source.debuffs.erase(debuff)
	for buff in source.buffs:
		if "roll_increase" in buff:
			roll += buff.roll_increase
			buff.turns -= 1
			var buff_icon = get_node("StatusBar/" + buff.name)
			buff_icon.tooltip_text = ""
			for key in buff.keys():
				buff_icon.tooltip_text += key + ": " +  str(buff[key]) + "\n"
			if buff.turns == 0:
				buff_icon.queue_free()
				source.buffs.erase(buff)
	if roll < 0:
		roll = 0
	elif roll > 7:
		roll = 7
	return roll_values[roll]


## Rolls dice to choose effects
func break_roll(source, roll_values):
	var roll = randi()%roll_values.size()
	for debuff in source.debuffs:
		if "break_roll_decrease" in debuff:
			roll -= debuff.break_roll_decrease
			debuff.turns -= 1
			var debuff_icon = get_node("StatusBar/" + debuff.name)
			debuff_icon.tooltip_text = ""
			for key in debuff.keys():
				debuff_icon.tooltip_text += key + ": " +  str(debuff[key]) + "\n"
			if debuff.turns == 0:
				debuff_icon.queue_free()
				source.debuffs.erase(debuff)
	for buff in source.buffs:
		if "break_roll_increase" in buff:
			roll += buff.break_roll_increase
			buff.turns -= 1
			var buff_icon = get_node("StatusBar/" + buff.name)
			buff_icon.tooltip_text = ""
			for key in buff.keys():
				buff_icon.tooltip_text += key + ": " +  str(buff[key]) + "\n"
			if buff.turns == 0:
				buff_icon.queue_free()
				source.buffs.erase(buff)
	if roll < 0:
		roll = 0
	elif roll > 7:
		roll = 7
	return roll_values[roll]


## Activates damage over time debuffs
func proc_dots(target):
	var debuffs = target.debuffs
	for dict in debuffs:
		if "dot" in dict:
			target.health -= dict.dot 
			dict.turns -= 1
			var debuff_icon = get_node("StatusBar/" + dict.name)
			debuff_icon.tooltip_text = ""
			for key in dict.keys():
				debuff_icon.tooltip_text += key + ": " +  str(dict[key]) + "\n"
			if dict.turns == 0:
				debuff_icon.queue_free()
				target.debuffs.erase(dict)
			display_text(dict.name + " dealt " + str(dict.dot) + " damage to " + target.health_name +". ")
	if target.health <= 0:
		target.health = 0
	var target_health_bar = get_node(target.health_name + "HealthBar")
	set_health(target_health_bar, target.health, target.max_health)

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


## Calculates damage target takes
func calculate_damage(source, target, action_info, action_name):
	var damage = roll(source, action_info.damage)
	if action_info.effect != null:
		var effect = break_roll(source, action_info.effect)
		if effect == "Double Damage":
			display_text("Rolled double damage. ")
			damage *= 2
		elif effect == "Break":
			display_text(action_name + " broke :(. ")
			remove_item(action_name)
	for buff in source.buffs:
		if "damage_increase" in buff:
			damage += buff.damage_increase
			buff.turns -= 1
			var buff_icon = get_node("StatusBar/" + buff.name)
			buff_icon.tooltip_text = ""
			for key in buff.keys():
				buff_icon.tooltip_text += key + ": " +  str(buff[key]) + "\n"
			if buff.turns == 0:
				buff_icon.queue_free()
				source.buffs.erase(buff)
	return damage


## Applys effects from action and activates effects already on target such as debuffs, dots, buffs, etc.
func action(source, target, action_info, action_name):
	display_text(source.name + " used " + action_name + ". ")
	if action_info.damage != null:
		var damage = calculate_damage(source, target, action_info, action_name)
		damage(target, damage)
		display_text("Dealt " + str(damage) + " damage. ")
	if action_info.heal != null:
		var heal = action_info.heal * target.max_health
		heal(target, heal, action_name)
		display_text("Healed " + str(heal) + " health. ")
	if action_info.debuff != null:
		if not_in_arr(action_info.debuff.name, target.debuffs):
			target.debuffs.append(action_info.debuff.duplicate())
			display_text("Applied " + action_info.debuff.name + " debuff. ")
			var debuff_icon = ColorRect.new() ## Adds debuff icon
			debuff_icon.name = action_info.debuff.name
			debuff_icon.color = Color.PURPLE
			debuff_icon.custom_minimum_size = Vector2(25,0)
			debuff_icon.tooltip_text = ""
			for key in action_info.debuff.keys():
				debuff_icon.tooltip_text += key + ": " + str(action_info.debuff[key]) + "\n"
			$StatusBar.add_child(debuff_icon)
	if action_info.buff != null:
		if not_in_arr(action_info.buff.name, target.buffs):
			target.buffs.append(action_info.buff.duplicate())
			display_text("Applied " + action_info.buff.name + " buff. ")
			var buff_icon = ColorRect.new() ## Adds buff icon
			buff_icon.name = action_info.buff.name
			buff_icon.color = Color.LAWN_GREEN
			buff_icon.custom_minimum_size = Vector2(25,0)
			buff_icon.tooltip_text = ""
			for key in action_info.buff.keys():
				buff_icon.tooltip_text += key + ": " + str(action_info.buff[key]) + "\n"
			$StatusBar.add_child(buff_icon)
	if action_info.cleanse != null:
		for debuff in target.debuffs:
			if action_info.cleanse == debuff.name:
				var debuff_icon = get_node("StatusBar/" + action_info.cleanse)
				target.debuffs.erase(debuff)
				debuff_icon.queue_free()
				display_text("Cleansed " + action_info.cleanse + ". ")
	if action_name in consumables: ## Removes player consumables after used
		remove_item(action_name)
	if "attacks_left" in action_info.keys(): ## If ran out of amount of actions
		action_info.attacks_left -= 1
		if action_info.attacks_left == 0:
			remove_item(action_name)
	if target.health == 0:
		finish_battle(target)


## Ends battle and switches to next scene
func finish_battle(target):
	if target == player:
		print(player.name)
	elif target == enemy:
		print(enemy.name)
	print(" Lost")
