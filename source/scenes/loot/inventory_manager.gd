extends Node

var active_inventory : Inventory  setget set_active_inventory, get_active_inventory
var active_item_ref : ItemDrop
var inventory_open : bool = false

var just_clicked = false

func _ready() -> void:
	Event.connect("inventory_slot_hover", self, "set_active_inventory")
	Event.connect("picked_up_item", self, "grab_from_ground")
	Event.connect("inventory_inactive", self, "set_active_inventory")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.is_action_pressed("left_click"):
		
		if active_item_ref == null:
			if !inventory_open:
				return
			
			grab_from_inventory()
	
		elif active_item_ref != null:
			if inventory_open:
				place_in_inventory(active_item_ref)
			else:
				active_item_ref.drop_position = (Global.character_reference as KinematicBody).global_translation
				active_item_ref.drop()
				active_item_ref = null
		


func grab_from_ground(item_ref: ItemDrop) -> void:
	active_item_ref = item_ref
	if inventory_open:
		item_ref.pickup()
	else:
		place_in_inventory(item_ref, false)


func place_in_inventory(item_ref, use_mouse_slot = true) -> void:
	item_ref.get_parent().remove_child(item_ref)
	# Add item to the item store node in the inventory
	active_inventory.item_store.add_child(item_ref)
	var success = active_inventory.place_item(item_ref, use_mouse_slot)
	if success:
		active_item_ref = null


func grab_from_inventory() -> void:
	active_item_ref = active_inventory.pickup_item()
	active_item_ref.get_parent().remove_child(active_item_ref)
	Global.level_reference.get_node("items").add_child(active_item_ref)


func set_active_inventory(inventory_slot_ref) -> void:
	if inventory_slot_ref == null:
		inventory_open = false
		active_inventory = Global.character_reference.inventory_reference
	else:
		inventory_open = true
		active_inventory = inventory_slot_ref.owning_inventory


func get_active_inventory():
	return active_inventory
