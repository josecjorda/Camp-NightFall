extends HSlider

@export 
var audio_bus_name:= "Master"
var bus_index: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
   bus_index = AudioServer.get_bus_index(audio_bus_name)
   value_changed.connect(_on_value_changed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_value_changed(value:float) -> void:
  AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
	


func _on_back_button_pressed():
 get_tree().change_scene_to_file("res://scenes/menus/options/options.tscn")
