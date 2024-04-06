extends Control

func _ready():
	var amt_kids_saved = Global.kids_saved.count(1)
	if amt_kids_saved == 0:
		$Label2.text = "You saved no one!!!!!!"
	elif amt_kids_saved == 3:
		$Label2.text = "You saved all the kids!!!!!!!"
	else:
		$Label2.text = "You saved "
		var kid_names = []
		if Global.kids_saved[0] == 1:
			kid_names.append("Anna")
		if Global.kids_saved[1] == 1:
			kid_names.append("Beth")
		if Global.kids_saved[2] == 1:
			kid_names.append("Ethan")
		for index in range(kid_names.size()):
			if index == 0:
				$Label2.text += kid_names[index]
			elif index == kid_names.size() - 1:
				$Label2.text += ", and " + kid_names[index]
			else:
				$Label2.text += ", " + kid_names[index]
		$Label2.text += "!!!!!!!"
