extends Control

# Sends signal to player to set character apperance and name
signal createCharacter(Gender, Hair, Name)

# Current Appearance
var currGender
var currHair
var currDirection

# Abbreviated Name: Full Name
var genders = Global.genders
var hairStyles = Global.hairStyles

# Abbreviated Name: file of synonyms
var genderFiles = {"M": "MALE_syns.txt", "F": "FEMALE_syns.txt"}
var hairStyleFiles = {"FADE": "FADE_syns.txt", "FRO": "FRO_syns.txt", "LH": "LH_syns.txt", "PT": "PT_syns.txt"
				 , "SH": "SH_syns.txt", "TT": "TT_syns.txt"}


# Arrays to keep track of positions for left and right buttons
var genderKeys = genders.keys()
var hairStyleKeys = hairStyles.keys()
var directionKeys = ["Forward", "Right", "Backward", "Left"]

var defaultPlayerName = "Counselor"
var defaultGender = "M"
var defaultHair = "SH"

func _ready():
	currGender = defaultGender
	currHair = defaultHair
	currDirection = "Forward"
	%CurrentGenderLabel.text = genders[currGender]
	%CurrentHairLabel.text = hairStyles[currHair]
	%PlayerAnimation.play(animationName())


# Chooses player apperance based on entered text
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
	
	
# Change gender
func _on_gender_left_button_pressed():
	var currIndex = genderKeys.find(currGender) 
	var newIndex = (currIndex - 1) % genderKeys.size()
	currGender = genderKeys[newIndex]
	%CurrentGenderLabel.text = genders[currGender]
	%PlayerAnimation.play(animationName())
	
# Change gender
func _on_gender_right_button_pressed():
	var currIndex = genderKeys.find(currGender) 
	var newIndex = (currIndex + 1) % genderKeys.size()
	currGender = genderKeys[newIndex]
	%CurrentGenderLabel.text = genders[currGender]
	%PlayerAnimation.play(animationName())

# Change hair
func _on_hair_left_button_pressed():
	var currIndex = hairStyleKeys.find(currHair) 
	var newIndex = (currIndex - 1) % hairStyleKeys.size()
	currHair = hairStyleKeys[newIndex]
	%CurrentHairLabel.text = hairStyles[currHair]
	%PlayerAnimation.play(animationName())
	
# Change hair
func _on_hair_right_button_pressed():
	var currIndex = hairStyleKeys.find(currHair) 
	var newIndex = (currIndex + 1) % hairStyleKeys.size()
	currHair = hairStyleKeys[newIndex]
	%CurrentHairLabel.text = hairStyles[currHair]
	%PlayerAnimation.play(animationName())
	

# Change direction
func _on_direction_left_button_pressed():
	var currIndex = directionKeys.find(currDirection) 
	var newIndex = (currIndex - 1) % directionKeys.size()
	currDirection = directionKeys[newIndex]
	%PlayerAnimation.play(animationName())
	
# Change direction
func _on_direction_right_button_pressed():
	var currIndex = directionKeys.find(currDirection) 
	var newIndex = (currIndex + 1) % directionKeys.size()
	currDirection = directionKeys[newIndex]
	%PlayerAnimation.play(animationName())
	
	
func animationName():
	var animationName = currGender + "-" + currHair + "-Run-" + currDirection + "-Animation"
	return animationName


# Moves to next scene
func _on_continue_pressed():
	var playerName = %NameEntry.text
	if playerName == "" : playerName = defaultPlayerName
	Global.playerName = playerName
	Global.gender = currGender
	Global.hair = currHair
	
	var next_scene = "res://scenes/main.tscn"
	get_tree().change_scene_to_file(next_scene)
