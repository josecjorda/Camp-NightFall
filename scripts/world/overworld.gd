extends Node2D

## All enterable buildings should be area2d nodes under the buildings node. 
## They should all have a OutsideView 2dnode that shows the outside view prior to entering 
## to adjust visibility.

func _ready():
	## Connects signals to buildings.
	for building in $buildings.get_children():
		building.body_entered.connect(building_entered.bind(building))
		building.body_exited.connect(building_exited.bind(building))


func building_entered(player, building):
	building.get_node("OutsideView").visible = false


func building_exited(player, building):
	building.get_node("OutsideView").visible = true
