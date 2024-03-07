extends Node
## A script used to hold general variables and functions which could be needed in multiple different scenes
## 
## @tutorial: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

## Gender[br] Abbreviation: Full Name
var genders = {"M": "Male", "F": "Female"}
## Hair Style[br] Abbreviation: Full Name
var hairStyles = {"FADE": "Fade", "FRO": "Afro", "LH": "Long Hair", "PT": "Pony Tail"
				 , "SH": "Short Hair", "TT": "Twisted Tail"}

# Characteristics. Stored as abbreviated name excluding playerName.
var playerName = "" ## Stores player name
var gender = "" ## Stores player abbreviated gender
var hair = "" ## Stores player abbreviated hair style


