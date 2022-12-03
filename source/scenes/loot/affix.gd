extends Item
class_name Affix

var display_text : String setget ,get_display_text
var stat setget set_stat
var value_min : float
var value_max : float
var price_modifier : float
var min_lvl : int setget set_level
var is_suffix : bool = false


func _init(text: String = "", stat = 999, value_min: float = 0, value_max: float = 0, price_modifier: float = 1, min_lvl: int = 0, is_suffix = false) -> void:
	self.display_text = text
	self.stat = stat
	self.value_min = value_min
	self.value_max = value_max
	self.price_modifier = price_modifier
	self.min_lvl = min_lvl
	self.is_suffix = is_suffix


func get_display_text() -> String:
	var affix_text = display_text
	if is_suffix:
		affix_text = "of " + affix_text
	return affix_text


func set_stat(stat) -> void:
	pass


func set_level(level) -> void:
	if level < 0:
		push_error("Quality level cannot be less than 0!")
	min_lvl = level
