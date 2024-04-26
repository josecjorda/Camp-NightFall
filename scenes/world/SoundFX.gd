extends Node2D

var seek_title = 0

var seek_roam = -5
var seek_kids =0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func discover_dead_kid():
	$"discover_dead".play()
func title_waiting():
	$"Title_Waiting".play(seek_title)
func title_waiting_end():
	seek_title  = $"Title_Waiting".get_playback_position( )
	$"Title_Waiting".stop()
func roaming():
	$Roaming.play(seek_roam)
func roaming_stop():
	seek_roam = $"Roaming".get_playback_position( )
	$"Roaming".stop()
func save_kids():
	$"SaveTheKids".play(seek_kids)
func save_kids_stop():
	seek_kids = $"Roaming".get_playback_position( )
	$"SaveTheKids".stop()
func _process(delta):
	pass
