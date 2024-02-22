extends Control

# Sends signal to player to change characters appearance
signal updateAppearance(Gender, Hair)
signal updateName(Name)

# Current Appearance
var currGender = "M"
var currHair = "FADE"
# Name: file of synonyms
var genders = {"M": "MALE_syns.txt", "F": "FEMALE_syns.txt"}
var hairStyles = {"FADE": "FADE_syns.txt", "FRO": "FRO_syns.txt", "LH": "LH_syns.txt", "PT": "PT_syns.txt"
				 , "SH": "SH_syns.txt", "TT": "TT_syns.txt"}

# Arrays of keys use for keeping track of assets in SettingsBox
var gendersArr = genders.keys()
var hairStylesArr = hairStyles.keys()

# Full name of genders and hair styles that will show up in menu
var visibleGenders = {"M": "Male", "F": "Female"}
var visibleHairStyles = {"FADE": "Fade", "FRO": "Afro", "LH": "Long Hair", "PT": "Pony Tail"
				 , "SH": "Short Hair", "TT": "Twisted Tail"}

# Called when the node enters the scene tree for the first time.
func _ready():
	var initialGender = currGender
	var initialHair = currHair
	updateAppearance.emit(initialGender, initialHair)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Chooses player apperance based on entered text
func _on_create_button_pressed():
	# Randomly initializes gender and hair style
	var genderKeys = genders.keys()
	var hairKeys = hairStyles.keys()
	var chosenGender = genderKeys[randi()%genders.size()]
	var chosenHair = hairKeys[randi()%hairKeys.size()]
	var foundGender = false
	var foundHair = false
	
	var textInput = $TextBox/ColorRect2/LineEdit.text.to_lower().split(" ")
	# Compares gender synonyms
	var genderFolder = "res://synonyms/gender"
	for gender in genders.keys():
		var file = FileAccess.open(genderFolder + "/" + genders[gender], FileAccess.READ)
		var synonyms = file.get_as_text(true).split("\n")
		for word in textInput:
			for synonym in synonyms:
				if word == synonym:
					chosenGender = gender
					foundGender = true
					break
			if foundGender == true : break
		if foundGender == true : file.close(); break
		file.close()
		
	# Compares hair synonyms
	var hairFolder = "res://synonyms/hair"
	for hair in hairStyles.keys():
		var file = FileAccess.open(hairFolder + "/" + hairStyles[hair], FileAccess.READ)
		var synonyms = file.get_as_text(true).split("\n")
		for word in textInput:
			for synonym in synonyms:
				if word == synonym:
					chosenHair = hair
					foundHair = true
					break
			if foundHair == true : break
		if foundHair == true : file.close(); break
		file.close()
		
	# Change current gender and hair name on settings box
	currGender = chosenGender
	currHair = chosenHair
	%CurrentGenderLabel.text = visibleGenders[chosenGender]
	%CurrentHairLabel.text = visibleHairStyles[chosenHair]
	
	# Apply gender and hair
	updateAppearance.emit(chosenGender, chosenHair)

# SettingsBox buttons
func _on_gender_left_button_pressed():
	var gendIndex = gendersArr.find(currGender) 
	var newIndex = gendIndex - 1
	if newIndex == -1:
		newIndex = gendersArr.size() - 1
	currGender = gendersArr[newIndex]
	
	%CurrentGenderLabel.text = visibleGenders[currGender]
	
func _on_gender_right_button_pressed():
	var gendIndex = gendersArr.find(currGender) 
	var newIndex = gendIndex + 1
	if newIndex == gendersArr.size():
		newIndex = 0
	currGender = gendersArr[newIndex]
	
	%CurrentGenderLabel.text = visibleGenders[currGender]
	
func _on_hair_left_button_pressed():
	var hairIndex = hairStylesArr.find(currHair) 
	var newIndex = hairIndex - 1
	if newIndex == -1:
		newIndex = hairStylesArr.size() - 1
	currHair = hairStylesArr[newIndex]
	
	%CurrentHairLabel.text = visibleHairStyles[currHair]
	
func _on_hair_right_button_pressed():
	var hairIndex = hairStylesArr.find(currHair) 
	var newIndex = hairIndex + 1
	if newIndex == hairStylesArr.size():
		newIndex = 0
	currHair = hairStylesArr[newIndex]
	
	%CurrentHairLabel.text = visibleHairStyles[currHair]
	
# Moves to next scene
func _on_continue_pressed():
	var Name = %NameEntry.text
	updateName.emit(Name)
