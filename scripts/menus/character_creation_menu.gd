extends Control
## A menu that allows the player to choose their appearance through text or buttons.
##
## Options to change appearane:[br]
## 1. TextBox: Text entered into the text box is compared to synonyms relating to an asset name.
## If a synonym is found for an asset, then it's chosen.[br]
## 2. SettingsBox: The player can also choose which assets to use by clicking left and right arrows
## to swap hair style and gender.

# Current Appearance
var currGender 
var currHair
var currDirection

var genders = Global.genders ## Dictionary[br]Abbreviated Name: Full Name
var hairStyles = Global.hairStyles ## Dictionary[br]Abbreviated Name: Full Name

## Dictionary[br]Abbreviated Name: file name of synonyms
var genderFiles = {"M": "MALE_syns.txt", "F": "FEMALE_syns.txt"}
## Dictionary[br]Abbreviated Name: file name of synonyms
var hairStyleFiles = {"FADE": "FADE_syns.txt", "FRO": "FRO_syns.txt", "LH": "LH_syns.txt", "PT": "PT_syns.txt"
				 , "SH": "SH_syns.txt", "TT": "TT_syns.txt"}


var genderKeys = genders.keys() ## Array to keep track of positions for left and right buttons
var hairStyleKeys = hairStyles.keys() ## Array to keep track of positions for left and right buttons
var directionKeys = ["Forward", "Right", "Backward", "Left"] ## Array to keep track of positions for left and right buttons

var defaultPlayerName = "Counselor" 
var defaultGender = "M"
var defaultHair = "SH"

## Sets starting player animation from defaultPlayerName, defaultGender, and defaultHair
func _ready():
	currGender = defaultGender
	currHair = defaultHair
	currDirection = "Forward"
	%CurrentGenderLabel.text = genders[currGender]
	%CurrentHairLabel.text = hairStyles[currHair]
	%PlayerAnimation.play(animationName())


## Chooses player apperance based on text entered into character creation text box.[br]
## Uses two main for loops to compare each word entered and each asset and their synonyms. If there is a match, 
## then that asset is chosen. This happens for the gender assets and the hair style assets.
func _on_create_button_pressed():
	# Randomly initializes gender and hair style
	var genderKeys = genders.keys()
	var hairKeys = hairStyles.keys()
	var chosenGender = genderKeys[randi()%genders.size()]
	var chosenHair = hairKeys[randi()%hairKeys.size()]
	var foundGender = false
	var foundHair = false
	
	var textInput = %TextBoxInput.text.to_lower().split(" ")
	# Compares gender synonyms
	var genderFolder = "res://synonyms/gender"
	for word in textInput:
		for gender in genders.keys():
			var file = FileAccess.open(genderFolder + "/" + genderFiles[gender], FileAccess.READ)
			var synonyms = file.get_as_text(true).split("\n")
			file.close()
			for synonym in synonyms:
				if word == synonym:
					chosenGender = gender
					foundGender = true
					break
			if foundGender == true : break
		if foundGender == true : break
		
	# Compares hair synonyms
	var hairFolder = "res://synonyms/hair"
	for word in textInput:
		for hair in hairStyles.keys():
			var file = FileAccess.open(hairFolder + "/" + hairStyleFiles[hair], FileAccess.READ)
			var synonyms = file.get_as_text(true).split("\n")
			file.close()
			for synonym in synonyms:
				if word == synonym:
					chosenHair = hair
					foundHair = true
					break
			if foundHair == true : break
		if foundHair == true : break
		
	# Change current gender and hair
	currGender = chosenGender
	currHair = chosenHair
	%CurrentGenderLabel.text = genders[chosenGender]
	%CurrentHairLabel.text = hairStyles[chosenHair]
	%PlayerAnimation.play(animationName())
	
	
## Chooses gender in genderKeys one index back
func _on_gender_left_button_pressed():
	var currIndex = genderKeys.find(currGender) 
	var newIndex = (currIndex - 1) % genderKeys.size()
	currGender = genderKeys[newIndex]
	%CurrentGenderLabel.text = genders[currGender]
	%PlayerAnimation.play(animationName())
	
## Chooses gender in genderKeys one index forward
func _on_gender_right_button_pressed():
	var currIndex = genderKeys.find(currGender) 
	var newIndex = (currIndex + 1) % genderKeys.size()
	currGender = genderKeys[newIndex]
	%CurrentGenderLabel.text = genders[currGender]
	%PlayerAnimation.play(animationName())

## Chooses hair style in hairStyleKeys one index back
func _on_hair_left_button_pressed():
	var currIndex = hairStyleKeys.find(currHair) 
	var newIndex = (currIndex - 1) % hairStyleKeys.size()
	currHair = hairStyleKeys[newIndex]
	%CurrentHairLabel.text = hairStyles[currHair]
	%PlayerAnimation.play(animationName())
	
## Chooses hair style in hairStyleKeys one index forward
func _on_hair_right_button_pressed():
	var currIndex = hairStyleKeys.find(currHair) 
	var newIndex = (currIndex + 1) % hairStyleKeys.size()
	currHair = hairStyleKeys[newIndex]
	%CurrentHairLabel.text = hairStyles[currHair]
	%PlayerAnimation.play(animationName())
	

## Chooses direction in directionKeys one index back
func _on_direction_left_button_pressed():
	var currIndex = directionKeys.find(currDirection) 
	var newIndex = (currIndex - 1) % directionKeys.size()
	currDirection = directionKeys[newIndex]
	%PlayerAnimation.play(animationName())
	
## Chooses direction in directionKeys one index forward
func _on_direction_right_button_pressed():
	var currIndex = directionKeys.find(currDirection) 
	var newIndex = (currIndex + 1) % directionKeys.size()
	currDirection = directionKeys[newIndex]
	%PlayerAnimation.play(animationName())
	

## Uses variables holding current appearance and direction to create the string name
## for the correlating player animation
func animationName():
	var animationName = currGender + "-" + currHair + "-Run-" + currDirection + "-Animation"
	return animationName


## Sets player's appearance and name in global script. Then moves to next scene.
func _on_continue_pressed():
	var playerName = %NameEntry.text
	if playerName == "" : playerName = defaultPlayerName
	Global.playerName = playerName
	Global.gender = currGender
	Global.hair = currHair
	
	var next_scene = "res://scenes/world/overworld.tscn"
	var time_start =  Time.get_ticks_msec()
	Global.time_start = time_start
	SoundFx.title_waiting_end()
	get_tree().change_scene_to_file(next_scene)
