extends Node
## This script is used to store the different entitiy classes used in combat.gd.
##
## These entities include the player and enemies.[br]
## Each class holds relevant information used in combat such as movesets and status information of each entity.


## Monster class. This is the main enemy of the game.
class monster_class:
	var name = "Monster"
	var health_name = "Enemy" ## Correlates to health bar name
	var max_health = 100
	var health = max_health
	var buffs = []
	var debuffs = []
	var actions = { ## Index of damage and effect arrays will correlate with dice rolls
		"Spectral Scream": {
			"damage" : null,
			"effect" : null,
			"heal" : null,
			"debuff" : {"name" : "fear", "turns" : 4, "roll_decrease" : 2},
			"buff" : null,
			"cleanse" : null,
			"cool_down" : 8,
			"last_used" : 100
		},
		"Revenant Rip": {
			"damage" : [0, 0, 0, 5*2, 6*2, 7*2, 8*2, 9*2],
			"effect" : null,
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null,
			"cool_down" : 0,
			"last_used" : 100
		},
		"Ghast Blast": {
			"damage" : [0, 0, 2, 3, 3, 4, 4, 4],
			"effect" : null,
			"heal" : null,
			"debuff" : {"name" : "poison", "turns": 5, "dot": 10},
			"buff" : null,
			"cleanse" : null,
			"cool_down" : 8,
			"last_used" : 100
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
			"cleanse" : null,
			"tool_tip" : "Low risk low reward"
		},
		"Axe": {
			"damage" : [0, 0, 0, 6, 6, 7, 8, 9],
			"effect" : ["Break", "Break", "Break", "Nothing", "Nothing", "Nothing", "Nothing", "Double Damage"],
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null,
			"tool_tip" : "High risk high reward"
		},
		"Shotgun": {
			"damage" : [0, 0, 9, 9, 9, 10, 10, 11],
			"effect" : null,
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null,
			"tool_tip" : "Consistent weapon"
		},
		"Machete": {
			"damage" : [0, 0, 3, 3, 4, 4, 4, 5],
			"effect" : ["Break", "Break", "Nothing", "Nothing", "Nothing", "Nothing", "Nothing", "Double Damage"],
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null,
			"tool_tip" : "Low risk medium reward"
		},
		"knife": {
			"damage" : [0, 0, 3, 3, 3, 3, 4, 4],
			"effect" : ["Break", "Break", "Nothing", "Nothing", "Nothing", "Nothing", "Nothing", "Double Damage"],
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null,
			"tool_tip" : "Low risk medium reward"
		},
		"Boltcutters": {
			"damage" : [0, 0, 3, 3, 3, 3, 4, 4],
			"effect" : ["Break", "Break", "Nothing", "Nothing", "Nothing", "Nothing", "Nothing", "Double Damage"],
			"heal" : null,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null,
			"tool_tip" : "Low risk medium reward"
		},
		"Soda": {
			"damage" : null,
			"effect" : null,
			"heal" : 1.0/5.0,
			"debuff" : null,
			"buff" : null,
			"cleanse" : "poison",
			"tool_tip" : "Heals for low amount and removes poison"
		},
		"Crackers": {
			"damage" : null,
			"effect" : null,
			"heal" : 3.0/5.0,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null,
			"tool_tip" : "Heals for moderate amount"
		},
		"Bandages": {
			"damage" : null,
			"effect" : null,
			"heal" : 1.0,
			"debuff" : null,
			"buff" : null,
			"cleanse" : null,
			"tool_tip" : "Heals for high amount"
		},
		"Alcohol": {
			"damage" : null,
			"effect" : null,
			"heal" : null,
			"debuff" : null,
			"buff" : {"name" : "alcohol", "turns": 3, "damage_increase": 1},
			"cleanse" : "fear",
			"tool_tip" : "Buffs damage rolls and removes fear"
		},
		"Chocolate": {
			"damage" : null,
			"effect" : null,
			"heal" : 2.0/5.0,
			"debuff" : null,
			"buff" : {"name" : "chocolate bar", "turns": 3, "break_roll_increase": 1},
			"cleanse" : null,
			"tool_tip" : "Heals for moderate amount and increases effect rolls"
		}
		
	}
