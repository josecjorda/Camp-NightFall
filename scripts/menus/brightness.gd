extends HSlider


# Called when the node enters the scene tree for the first time.


func _on_value_changed(value):
	WorldBrightness.environment.adjustment_brightness = value


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options/options.tscn")
