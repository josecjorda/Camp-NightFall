extends Node2D

## All enterable buildings should be area2d nodes under the buildings node. 
## They should all have a OutsideView 2dnode that shows the outside view prior to entering 
## to adjust visibility. Set OutsideView ordering z index to 1 so items/npcs don't appear on top
## of the outside layer. Player should appear on top of outside view so keep z index as 2.
## When adding buildings, turn off OutsideView visibility for convenience when
## placing npcs/items on map.[br]
##
## Make sure to set proper collison layers for nodes other wise buildings might think node is player.[br]
##
## Everythings modulated except for camp fire. other_locations are modulated individually.
var mod = "#808080" #Current modulation for map


func _ready():
	## Connects signals to buildings.
	$MapBackground.get_node("map").play("default")
	$other_locations/Campfire.get_node("Fire/fire").play("default")
	$other_locations/Archery.get_node("AnimatedSprite2D").play("default")
	for building in $buildings.get_children():
		building.get_node("OutsideView").visible = true
		building.body_entered.connect(building_entered.bind(building))
		building.body_exited.connect(building_exited.bind(building))

## Makes interiror of building visible
func building_entered(player, building):
	building.get_node("OutsideView").visible = false
	dim_except_for(building)

## Shows outside view of building
func building_exited(player, building):
	building.get_node("OutsideView").visible = true
	undim_all()


## Essentially makes everything outside the building one's currently in black.
## To make outside of building dimmed out, modulate map, other_locations, and buildings except for entered one
func dim_except_for(building):
	$other_locations.visible = false
	$MapBackground.modulate = "black"
	var buildings = $buildings.get_children()
	buildings.erase(building)
	for build in buildings:
		build.get_node("OutsideView").modulate = "black"


## Undims world and buildings/locations. Don't know why outside view needs white and map needs mod.
func undim_all():
	$other_locations.visible = true
	$MapBackground.modulate = mod
	var buildings = $buildings.get_children()
	for build in buildings:
		build.get_node("OutsideView").modulate = "white"
