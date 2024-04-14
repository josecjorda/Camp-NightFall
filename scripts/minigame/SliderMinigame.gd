extends Node2D
## Simple minigame module crosshair moves across target, player must right/left click when
## crosshair is on target for dopamine

signal hitTimingTarget ## sent to game master that target has been hit successfully
signal missedTimingTarget ## sent to game master that input was recieved but not good

@onready var playArea = get_node("PlayArea") ## area where crosshair + targets will be 
@onready var isHorizontal :bool = (playArea.size.x >= playArea.size.y) 

@export var padding :int = 10 ## increasing -> shrinks spawnable area of targets within playArea

@export var targetSize_ :Vector2 = Vector2(10,50) ## size of the target
@onready var targetSize :Vector2 = targetSize_.clamp(Vector2(1,1),playArea.size)
@onready var targetPos :Vector2 = Vector2(0,0)
@onready var targetColor :Color = Color.RED

@export var graceArea :int = 10 ## increasing -> larger hit box, invisible to player, makes less frustrating

@export var crosshairSize_ :Vector2 = Vector2(10,10) ## size of crosshair
@onready var crosshairSize :Vector2 = crosshairSize_.clamp(Vector2(1,1),playArea.size/2)
@onready var crosshairPos :Vector2 = Vector2(playArea.position.x + playArea.size.x/2, \
											 playArea.position.y +playArea.size.y/2)
@export var crosshairColor :Color = Color.BLUE ## color of crosshair

@export var crosshairSpeed :int = 250 ## speed of the crosshair
@onready var velocity :Vector2 = Vector2(0,0)
@export var isBounce :bool = true ## will the crosshair bounce or restart at beginning?

@export var isAlternating :bool = true ## will the target input change?
@onready var leftColor :Color = Color.RED 
@onready var rightColor :Color = Color.GREEN

func _ready():
	playArea.visible = false
	if(isHorizontal):
		targetPos.y = playArea.position.y + (playArea.size.y/2) - (targetSize.y/2)
		velocity = Vector2(crosshairSpeed,0) 
		crosshairPos.y = playArea.position.y + (playArea.size.y/2) - (crosshairSize.y/2)
	else:
		targetPos.x = playArea.position.x + (playArea.size.x/2) - (targetSize.x/2)
		velocity = Vector2(0,crosshairSpeed)
		crosshairPos.x = playArea.position.x + (playArea.size.x/2) - (crosshairSize.x/2)
	getNewTarget()

func _process(delta):
	queue_redraw()
	crosshairPos += velocity * delta
	if(crosshairOutOfBounds()):
		if(isBounce):
			velocity = -1 * velocity
		else:
			if(isHorizontal):
				crosshairPos.x = playArea.position.x
			else:
				crosshairPos.y = playArea.position.y

func _draw():
	draw_rect(Rect2(targetPos.x+3, targetPos.y+3, targetSize.x, targetSize.y), Color.BLACK) # draw drop shadows
	draw_rect(Rect2(crosshairPos.x +3, crosshairPos.y +3, crosshairSize.x, crosshairSize.y), Color.BLACK)
	draw_rect(Rect2(targetPos.x, targetPos.y, targetSize.x, targetSize.y), targetColor) # draw target
	draw_rect(Rect2(crosshairPos.x, crosshairPos.y, crosshairSize.x, crosshairSize.y), crosshairColor) # draw crosshair

func crosshairOutOfBounds():
	if(crosshairPos.y + crosshairSize.y > playArea.position.y + playArea.size.y \
	|| crosshairPos.y < playArea.position.y \
	|| crosshairPos.x + crosshairSize.x > playArea.position.x + playArea.size.x \
	|| crosshairPos.x < playArea.position.x) :
		return true
	return false

func _input(event):
	if ((event is InputEventMouseButton) && (event.is_pressed())):
		if ((event.button_index == MOUSE_BUTTON_LEFT || event.button_index == MOUSE_BUTTON_RIGHT)):
			if crosshairInTarget():
				if(isAlternating):
					if(targetColor == leftColor && event.button_index == MOUSE_BUTTON_LEFT):
						success()
					elif(targetColor == rightColor && event.button_index == MOUSE_BUTTON_RIGHT):
						success()
				else:
					success()
			else:
				fail()

func crosshairInTarget():
	if(crosshairPos.x >= targetPos.x - graceArea \
		&& crosshairPos.x + crosshairSize.x <= targetPos.x + targetSize.x + graceArea \
		&& isHorizontal) \
		|| (crosshairPos.y >= targetPos.y - graceArea \
		&& crosshairPos.y + crosshairSize.y <= targetPos.y + targetSize.y + graceArea \
		&& !isHorizontal):
			return true
	return false
				
func success():
	getNewTarget()
	if(isAlternating):
		if(targetColor == leftColor):
			targetColor = rightColor
		else:
			targetColor = leftColor
	hitTimingTarget.emit()
	
func getNewTarget():
	if(isHorizontal):
		targetPos.x = randi_range(playArea.position.x+padding ,playArea.position.x+playArea.size.x-targetSize.x-padding)
	else:
		targetPos.y = randi_range(playArea.position.y+padding ,playArea.position.y+playArea.size.y-targetSize.y-padding)

func fail():
	missedTimingTarget.emit()
	



