extends Node 


# Public signals

signal setting_changed(name, value)


# Private consts

const SETTINGS_PATH = "settings.json"


# Private variables 

var settings: Dictionary = {}
var settings_default: Dictionary = {
	"volume": {
		"master": 1.0,
		"music": 1.0,
		"sound_effects": 1.0,
	},
	"input": {},
	"graphics": {
		"fullscreen": false,
	},
	"gameplay": {
		"shake_intensity": 1.0,
	},
}


# Lifecycle methods

func _ready() -> void: 
	settings_load()


# Public methods 

func get(name, default = null): # Variant
	pass


func set(name: String, value, save: bool = false) -> void: 
	pass


func settings_load() -> void: 
	if IOHelper.file_exists(SETTINGS_PATH):
		var setting_string: String = IOHelper.file_load(SETTINGS_PATH)
		
		var test_json_conv = JSON.new()
		test_json_conv.parse(setting_string)
		settings = test_json_conv.get_data()
		
		if merge_settings(settings, settings_default): 
			settings_save()
		
		# TODO: Logger
	else:
		settings = settings_default
		
		settings_save()
		
		# TODO: Logger


func settings_save() -> void: 
	var setting_string: String = JSON.new().stringify(settings)
		
	IOHelper.file_save(SETTINGS_PATH, setting_string)


# Private methods 

func merge_settings(a: Dictionary, b: Dictionary) -> bool: 
	var changed: bool = false
	
	for key in b: 
		if !a.has(key) || typeof(a[key]) != typeof(b[key]):
			a[key] = b[key]
			
			changed = true
		elif b[key] is Dictionary:
			changed = changed || merge_settings(a[key], b[key]) 
			
	return changed
