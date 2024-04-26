extends Control

var save_path = "res://load_files"
# Called when the node enters the scene tree for the first time.
func _ready():
	var files = []
	var dir = DirAccess.open(save_path)
	
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func load_selected():
	if ResourceLoader.exists(save_path):
		return load(save_path)
	return null

