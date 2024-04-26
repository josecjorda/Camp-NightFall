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

var elapsed_time = 0 #https://www.reddit.com/r/godot/comments/9e4bn5/elapsed_time_in_milliseconds/
var kids_saved = [0,0,0] #Anna is index 0, Beth is index 1, Ethan is index 2, when child is saved, their value turns to 1
# Inventory array that will be passed on to the final boss fight
var invArr = []
var time_start = 0
#Determinants


		#Section Determinants
var rope_bait = false
var short_cut_hedge = false
var bolt_cutters = false
var lighters = false
var bandages =false
var axe = false
var machete = false
var knife = false
var save_dict = {
	'rope_bait': rope_bait,
	'boltcutters': bolt_cutters,
	'lighters': lighters,
	'bandages': bandages,
	"axe": axe,
	"machete": machete,
	"knife": knife,
	"playerName": playerName,
	"gender": gender,
	"hair":hair,
	"location":location,
	"inventory":invArr,
	"time_elapsed":elapsed_time
	}
func _ready():
	
	pass
	
func _process(_delta):
	var time_now = Time.get_ticks_msec()
	elapsed_time =  (time_now - time_start)/60000
	if elapsed_time == 2:
		print(elapsed_time)
	
	if rope_bait==true:
		print("Filler")
	if bolt_cutters == true or knife == true or machete == true or axe == true :
		print("Filler")
	if lighters == true and bandages == true :
		print("Filler")
	if machete == true:
		short_cut_hedge = true
	save_dict["rope_bait"] = rope_bait
	save_dict['boltcutters' ]= bolt_cutters
	save_dict["lighters"] = lighters
	save_dict["bandages"] = bandages
	save_dict["axe"] = axe
	save_dict["machete"] = machete
	save_dict["knife"] = knife
	save_dict["playerName"] = playerName
	save_dict["gender"] = gender
	save_dict["hair"] = hair
	save_dict["location"] = location
	save_dict["inventory"] = invArr
	save_dict["time_elapsed"] = elapsed_time

  

