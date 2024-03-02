extends Control

# Sends signal to player to set character apperance and name
signal createCharacter(Gender, Hair, Name)

# Current Appearance
var currGender
var currHair
var currDirection

# Abbreviated Name: file of synonyms
var genders = {"M": "MALE_syns.txt", "F": "FEMALE_syns.txt"}
var hairStyles = {"FADE": "FADE_syns.txt", "FRO": "FRO_syns.txt", "LH": "LH_syns.txt", "PT": "PT_syns.txt"
				 , "SH": "SH_syns.txt", "TT": "TT_syns.txt"}

# Arrays to keep track of positions for left and right buttons
var gendersArr = genders.keys()
var hairStylesArr = hairStyles.keys()
var directionsArr = ["Forward", "Right", "Backward", "Left"]

# Full name of genders and hair styles that will show up in menu
var visibleGenders = {"M": "Male", "F": "Female"}
var visibleHairStyles = {"FADE": "Fade", "FRO": "Afro", "LH": "Long Hair", "PT": "Pony Tail"
				 , "SH": "Short Hair", "TT": "Twisted Tail"}

# Called when the node enters the scene tree for the first time.
func _ready():
	currGender = "M"
	currHair = "SH"
	currDirection = "Forward"
	%CurrentGenderLabel.text = visibleGenders[currGender]
	%CurrentHairLabel.text = visibleHairStyles[currHair]
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
			var file = FileAccess.open(genderFolder + "/" + genders[gender], FileAccess.READ)
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
			var file = FileAccess.open(hairFolder + "/" + hairStyles[hair], FileAccess.READ)
			var synonyms = file.get_as_text(true).split("\n")
			file.close()
			for synonym in synonyms:
				if word == synonym:
					chosenHair = hair
					foundHair = true
					break
			if foundHair == true : break
		if foundHair == true : break
		
	# Change current gender and hair name on settings box
	currGender = chosenGender
	currHair = chosenHair
	%CurrentGenderLabel.text = visibleGenders[chosenGender]
	%CurrentHairLabel.text = visibleHairStyles[chosenHair]
	
	# Show animation
	%PlayerAnimation.play(animationName())
	
	
# SettingsBox buttons
func _on_gender_left_button_pressed():
	# Change gender
	var gendIndex = gendersArr.find(currGender) 
	var newIndex = gendIndex - 1
	if newIndex == -1:
		newIndex = gendersArr.size() - 1
	currGender = gendersArr[newIndex]
	
	# Change current gender on settings box
	%CurrentGenderLabel.text = visibleGenders[currGender]
	
	# Show animation
	%PlayerAnimation.play(animationName())
	
func _on_gender_right_button_pressed():
	# Change gender
	var gendIndex = gendersArr.find(currGender) 
	var newIndex = gendIndex + 1
	if newIndex == gendersArr.size():
		newIndex = 0
	currGender = gendersArr[newIndex]
	
	# Change current gender on settings box
	%CurrentGenderLabel.text = visibleGenders[currGender]
	
	# Show animation
	%PlayerAnimation.play(animationName())
	
func _on_hair_left_button_pressed():
	# Change hair
	var hairIndex = hairStylesArr.find(currHair) 
	var newIndex = hairIndex - 1
	if newIndex == -1:
		newIndex = hairStylesArr.size() - 1
	currHair = hairStylesArr[newIndex]
	
	# Change current hair name on settings box
	%CurrentHairLabel.text = visibleHairStyles[currHair]
	
	# Show animation
	%PlayerAnimation.play(animationName())
	
func _on_hair_right_button_pressed():
	# Change hair
	var hairIndex = hairStylesArr.find(currHair) 
	var newIndex = hairIndex + 1
	if newIndex == hairStylesArr.size():
		newIndex = 0
	currHair = hairStylesArr[newIndex]
	
	# Change current hair name on settings box
	%CurrentHairLabel.text = visibleHairStyles[currHair]
	
	# Show animation
	%PlayerAnimation.play(animationName())
	

# Facing direction buttons	
func _on_direction_left_button_pressed():
	# Change direction
	var directionIndex = directionsArr.find(currDirection) 
	var newIndex = directionIndex - 1
	if newIndex == -1:
		newIndex = directionsArr.size() - 1
	currDirection = directionsArr[newIndex]
	
	# Show animation
	%PlayerAnimation.play(animationName())
	
func _on_direction_right_button_pressed():
	# Change direction
	var directionIndex = directionsArr.find(currDirection) 
	var newIndex = directionIndex + 1
	if newIndex == directionsArr.size():
		newIndex = 0
	currDirection = directionsArr[newIndex]
	
	# Show animation
	%PlayerAnimation.play(animationName())
	
	
func animationName():
	var animationName = currGender + "-" + currHair + "-Run-" + currDirection + "-Animation"
	return animationName


# Moves to next scene
func _on_continue_pressed():
	var Name = %NameEntry.text
	if Name == "" : Name = "Counselor"
	createCharacter.emit(currGender, currHair, Name)
	
	var next_scene = "res://scenes/player/player.tscn"
	get_tree().change_scene_to_file(next_scene)
