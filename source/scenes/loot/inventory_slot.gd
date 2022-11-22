extends Control

export var is_occupied : bool = false setget set_occupied, get_occupied


func _on_inventory_slot_mouse_entered() -> void:
	Event.emit_signal("inventory_slot_hover", self)


func _on_inventory_slot_mouse_exited() -> void:
	Event.emit_signal("inventory_slot_hover", null)


func set_occupied(set_value: bool) -> void:
	is_occupied = set_value


func get_occupied() -> bool:
	return is_occupied
