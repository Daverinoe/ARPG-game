extends Control
class_name Inventory

enum TYPE {
	CHARACTER = 0,
	SHOP = 1,
	BELT = 2,
}

@export var num_rows : int = 10 # (int, 0, 100)
@export var num_cols : int = 10 # (int, 0, 100)
@export var slot_gap : int = 0
@export var inventory_type: TYPE = 0

var mouse_over_slot : set = set_mouse_over_slot
var slot_refs : Array = []

var item_reserve : ItemDrop # Used when hot-swapping items


@onready var grid_reference : GridContainer = $inventory_grid
@onready var inventory_slot = preload("res://source/scenes/loot/inventory_slot.tscn")
@onready var item_store = $"."


func _ready() -> void:
	grid_reference.columns = num_cols
	
	for x in range(num_cols * num_rows):
		var new_slot = inventory_slot.instantiate()
		new_slot.owning_inventory = self
		grid_reference.add_child(new_slot)
		slot_refs.push_back(new_slot)

	grid_reference.add_theme_constant_override("v_separation", slot_gap)
	grid_reference.add_theme_constant_override("h_separation", slot_gap)
	
	Event.connect("inventory_slot_hover",Callable(self,"set_mouse_over_slot"))
	
	await get_parent().ready
	Event.emit_signal("inventory_inactive", null)
	
	show()
	await get_tree().create_timer(0,1).timeout
	hide()


func set_mouse_over_slot(inventory_slot_ref) -> void:
	mouse_over_slot = inventory_slot_ref


func place_item(item_ref: ItemDrop, use_mouse_slot : bool = true) -> ItemDrop:
	var used_slot = null
	if use_mouse_slot:
		used_slot = mouse_over_slot
	else:
		var ind = 0
		while used_slot == null:
			if ind >= slot_refs.size():
				return item_ref
			var slot = slot_refs[ind]
			if !is_slot_occupied(slot) and will_item_fit(item_ref, slot):
				used_slot = slot
			ind += 1
	
	var old_item: ItemDrop = null
	
	if use_mouse_slot:
		old_item = used_slot.containing_item
	
	if !will_item_fit(item_ref, used_slot, old_item):
		return item_ref
	
	if old_item != null:
		pickup_item()
	
	var slot_index = slot_refs.find(used_slot)
	
	var start_index = index_to_xy(slot_index)
	set_slots_occupied(start_index, item_ref, true)
	
	var slot_position = used_slot.global_position
	print(used_slot)
	item_ref.place_item(slot_position)
	
	if self.visible:
		item_ref.visible = true
	else:
		item_ref.visible = false
	
	return old_item


func pickup_item() -> ItemDrop:
	if mouse_over_slot == null:
		return null
	
	# Get item from hovered slot
	var item = mouse_over_slot.containing_item
	
	if item == null:
		return null
	
	var start_index = find_start_index(item, index_to_xy(slot_refs.find(mouse_over_slot)))
	
	set_slots_occupied(start_index, item, false)
	
	item.pickup()
	
	return item


func find_start_index(item: ItemDrop, initial_index: Vector2) -> Vector2:
	
	var item_size = item.inventory_size
	
	var found_x_index = false
	var found_y_index = false
	var x_check = initial_index.x
	var y_check = initial_index .y
	
	while !found_x_index:
		x_check -= 1
		var index = xy_to_index(x_check, y_check)
		if slot_refs[index].containing_item != item:
			found_x_index = true
			x_check += 1
	while !found_y_index:
		y_check -= 1
		var index = xy_to_index(x_check, y_check)
		if slot_refs[index].containing_item != item:
			found_y_index = true
			y_check += 1
	
	return Vector2(x_check, y_check)


func will_item_fit(item_ref: ItemDrop, slot_ref, ignore_ref: ItemDrop = null) -> bool:
	var start_index = index_to_xy(slot_refs.find(slot_ref))
	var end_indices = item_ref.inventory_size + start_index
	
	# If the indices are outside of the bounds of the inventory, do nothing
	if end_indices.x > num_cols or end_indices.y > num_rows:
		return false
	
	# Check if any slots are already occupied, except mouse_over_slot (in which case item held should switch)
	for x in range(start_index.x, end_indices.x):
		for y in range(start_index.y, end_indices.y):
			var index = xy_to_index(x, y)
			var ref = slot_refs[index]
			if ref == mouse_over_slot or ref.containing_item == ignore_ref:
				continue
			if is_slot_occupied(ref):
				return false
	
	return true


func set_slots_occupied(start_index: Vector2, item_ref: ItemDrop, status: bool) -> bool:
	var end_indices = item_ref.inventory_size + start_index
	
	# If the indices are outside of the bounds of the inventory, do nothing
	if end_indices.x > num_cols or end_indices.y > num_rows:
		return false
	
	# Set occupied status
	for x in range(start_index.x, end_indices.x):
		for y in range(start_index.y, end_indices.y):
			var index = xy_to_index(x, y)
			var ref = slot_refs[index]
			ref.is_occupied = status
			if status:
				ref.containing_item = item_ref
			else:
				ref.containing_item = null
	
	return true
	


func xy_to_index(x: int = 0, y: int = 0) -> int:
	# Take in a (x, y) type reference, and give back the converted index
	return x + y * num_cols


func index_to_xy(index: int) -> Vector2:
	var x = index % num_cols
	return Vector2(x, (index - x) / num_cols)


func is_slot_occupied(slot_ref) -> bool:
	var index = slot_refs.find(slot_ref)
	var ref = slot_refs[index]
	if ref.has_method("get_occupied"):
		return ref.is_occupied
	return false


func show() -> void:
	self.visible = true
	set_item_visibilities(true)


func hide() -> void:
	Event.emit_signal("inventory_inactive", null)
	self.visible = false
	set_item_visibilities(false)


func set_item_visibilities(is_visible) -> void:
	if item_store.get_child_count() > 0:
		for child in item_store.get_children():
			child.visible = is_visible
