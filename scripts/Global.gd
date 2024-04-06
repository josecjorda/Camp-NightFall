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
var location = ""
var inventory = []
var elapsed_time = 0 #https://www.reddit.com/r/godot/comments/9e4bn5/elapsed_time_in_milliseconds/
var kids_saved = [0,0,0] #Anna is index 0, Beth is index 1, Ethan is index 2, when child is saved, their value turns to 1
# Inventory array that will be passed on to the final boss fight
var invArr = []

#Determinants


		#Section Determinants
var rope_bait = false
var short_cut_hedge = false
var bolt_cutters = false
var lighters = false
var bandages =false

		#Final Boss Determinants
var deteriorated_health = false



