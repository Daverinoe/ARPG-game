extends Control

export var is_occupied : bool = false setget set_occupied, get_occupied


func _ready() -> void:
	set_slot_size(self, Global.inventory_slot_size)
	set_slot_size($slot_texture, Global.inventory_slot_size)

func _on_inventory_slot_mouse_entered() -> void:
	Event.emit_signal("inventory_slot_hover", self)
	
	if is_occupied:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else:
		mouse_default_cursor_shape = Control.CURSOR_ARROW


func _on_inventory_slot_mouse_exited() -> void:
	Event.emit_signal("inventory_slot_hover", null)
	
	# Ensure mouse cursor is the right shape when leaving the inventory
	mouse_default_cursor_shape = Control.CURSOR_ARROW


func set_occupied(set_value: bool) -> void:
	is_occupied = set_value


func get_occupied() -> bool:
	return is_occupied


func set_slot_size(target, slot_size: int) -> void:
	target.rect_min_size = Vector2(slot_size, slot_size)
	target.rect_size = Vector2(slot_size, slot_size)
