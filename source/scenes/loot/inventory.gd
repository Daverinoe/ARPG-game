extends Control
class_name Inventory

enum TYPE {
	CHARACTER = 0,
	SHOP = 1,
	BELT = 2,
}

export(int, 0, 100) var num_rows : int = 10
export(int, 0, 100) var num_cols : int = 10
export var slot_gap : int = 0
export(TYPE) var inventory_type = 0

var mouse_over_slot setget set_mouse_over_slot
var slot_refs : Array = []

onready var grid_reference : GridContainer = $inventory_grid
onready var inventory_slot = preload("res://source/scenes/loot/inventory_slot.tscn")

func _ready() -> void:
	grid_reference.columns = num_cols
	
	for x in range(num_cols * num_rows):
		var new_slot = inventory_slot.instance()
		grid_reference.add_child(new_slot)
		slot_refs.push_back(new_slot)

	grid_reference.add_constant_override("vseparation", slot_gap)
	grid_reference.add_constant_override("hseparation", slot_gap)
	
	Event.connect("inventory_slot_hover", self, "set_mouse_over_slot")


func set_mouse_over_slot(inventory_slot_ref) -> void:
	mouse_over_slot = inventory_slot_ref


func xy_to_index(x: int = 0, y: int = 0) -> int:
	# Take in a (x, y) type reference, and give back the converted index
	return x + y * num_cols


func index_to_xy(index: int) -> Vector2:
	var x = index % num_cols
	return Vector2(x, (index - x) / num_cols)


func is_slot_occupied() -> bool:
	var index = slot_refs.find(mouse_over_slot)
	var ref = slot_refs[index]
	if ref.has_method("get_occupied"):
		return ref.is_occupied
	return false


