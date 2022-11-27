extends Control
class_name ItemDrop

export var item_scene : PackedScene = PackedScene.new()
export var sprite_file : StreamTexture
export(Item.ITEM_TYPE) var type : int = 0
export(Item.ITEM_SIZE) var item_size : int = 0
export(Item.RARITY) var rarity : int = 0
export var item_name : String = "TEST"
export var inventory_size : Vector2 = Vector2(1, 1)
export var base_cost : int = 10
export var is_dropped : bool = false

var drop_position : Vector3
var prefix
var suffix
var is_picked_up : bool = false

onready var item_reference_3d : RigidBody = $item_3d
onready var item_reference_2d : Control = $item_2d


func _enter_tree():
	# Set if magical, and set prefix and/or suffix
	# Update name
	pass


func _ready():
	var group_name = Item.ITEM_TYPE.keys()[type]
	if get_parent().name != "loot_manager" and is_in_group(group_name):
		remove_from_group(group_name)
	item_reference_3d.item_scene = self.item_scene
	item_reference_2d.sprite_file = self.sprite_file

	pause_and_remove(item_reference_2d)
	pause_and_remove(item_reference_3d)


func drop() -> void:
	if item_reference_2d.is_inside_tree():
		pause_and_remove(item_reference_2d)
	if !item_reference_3d.is_inside_tree():
		add_and_unpause(item_reference_3d)
	Global.can_control = true
	item_reference_3d.drop_position = self.drop_position
	item_reference_3d.drop()
	is_dropped = true
	print("Item dropped!")


func pause_and_remove(node_reference) -> void:
	node_reference.visible = false
	node_reference.pause_mode = Node.PAUSE_MODE_STOP
	self.remove_child(node_reference)


func add_and_unpause(node_reference) -> void:
	self.add_child(node_reference)
	node_reference.visible = true
	node_reference.pause_mode = Node.PAUSE_MODE_INHERIT


func pickup() -> void:
	if item_reference_3d.is_inside_tree():
		pause_and_remove(item_reference_3d)
	if !item_reference_2d.is_inside_tree():
		add_and_unpause(item_reference_2d)
	Global.can_control = false
	is_dropped = false
	item_reference_2d.set_process(true)
	is_picked_up = true
	print("Item picked up!")


func place_item(position_2d: Vector2) -> void:
	if item_reference_3d.is_inside_tree():
		pause_and_remove(item_reference_3d)
	if !item_reference_2d.is_inside_tree():
		add_and_unpause(item_reference_2d)
	is_dropped = false
	Global.can_control = true
	item_reference_2d.set_process(false)
	item_reference_2d.place_down(position_2d)
	print("Item placed!" + var2str(position_2d))


func _on_click_shield_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	var item_distance = item_reference_3d.global_translation.distance_to(Global.player_reference.global_translation)
	if event.is_action_pressed("left_click") and item_distance < 3.0:
		Event.emit_signal("picked_up_item", self)
