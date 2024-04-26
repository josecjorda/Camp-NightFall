extends Control

@onready var option_button = $HBoxContainer/OptionButton as OptionButton
const WINDOW_MODE_ARRAY: Array[String] = [
	"Full-Screen",
	"Window-Mode"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	add_window_mode_items()
	option_button.item_selected.connect(on_window_res_selected)
func add_window_mode_items()-> void:
	for window in WINDOW_MODE_ARRAY:
		option_button.add_item(window)
			# Replace with function body.
func on_window_res_selected(index:int)-> void:
	match index:
		0: #Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		1:  
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
