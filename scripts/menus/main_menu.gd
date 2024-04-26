extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	SoundFx.title_waiting()


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_save_button_pressed():
	var file  = FileAccess.open("res://load_files/save_file.save",FileAccess.WRITE)
	for i in Global.save_dict.size():
		file.store_line(str(Global.save_dict.keys()[i],":",Global.save_dict.values()[i],"\r").replace(" ","")) 
	file.close()
	
	
	


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/character_creation_menu.tscn")


func _on_load_button_pressed():
	get_tree().change_scene_to_file("res://scenes/save_load/saved_files.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options/options.tscn")


func _on_quit_pressed():
	print("Quit reached")
	
	get_tree().set_auto_accept_quit(true)
	get_tree().quit()

