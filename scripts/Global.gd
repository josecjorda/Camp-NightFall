extends Node
## A script used to hold general variables and functions which could be needed in multiple different scenes
## 
## @tutorial: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

## Gender[br] Abbreviation: Full Name
var genders = {"M": "Male", "F": "Female"}
## Hair Style[br] Abbreviation: Full Name
var hairStyles = {"FADE": "Fade", "FRO": "Afro", "LH": "Long Hair", "PT": "Pony Tail"
				 , "SH": "Short Hair", "TT": "Twisted Tail"}

# Characteristics
var playerName = "Counselor"  ## Stores player name
var gender = "" ## Stores player abbreviated gender
var hair = "" ## Stores player abbreviated hair style
var player_max_health = 100 ## Max health that the player can have
var player_health = 100 ## Stores current player health

# Inventory array that will be passed on to the final boss fight
var invArr = []


