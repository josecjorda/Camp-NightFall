extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options/volume_adjust.tscn")


func _on_bright_ness_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options/brightness.tcsn")


func _on_resolution_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options/options_res.tscn")


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
