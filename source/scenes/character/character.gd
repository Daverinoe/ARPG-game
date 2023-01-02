extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var camera = $sky_camera
@onready var inventory_reference = $inventory

var fireball = preload("res://source/scenes/character/attacks/skills/fireball.tscn")
@onready var navigation = owner.get_node("Node3D")
@onready var body = $CSGCylinder3D

var next_point = Vector3()
var target = Vector3()
var target_position = Vector3()

var new_velocity = Vector3()

var movement_speed:int = 8
var health:int = 100
var alive:bool = true
var moving:bool = false
var movement_held:bool = false


func _ready():
	Global.character_reference = self
	nav.set_navigation(navigation)
	Global.player_reference = self
	Global.camera_reference = $sky_camera
	InventoryManager.set_active_inventory(null)


func set_target_position(mouse_position : Vector3):
	if mouse_position != Vector3(0,0,0):
		nav.set_target_location(mouse_position)


func clear_target_position():
	nav.set_target_location(global_transform.origin)


func _physics_process(_delta):
	if !nav.is_target_reached():
		next_point = nav.get_next_location()
		var dir = (next_point - global_transform.origin)
		velocity = dir * movement_speed
		velocity.y = 0

		if dir != Vector3.ZERO:
			dir = dir.normalized()
			var look_pos = position + dir
			look_pos.y = get_global_transform().origin.y + 0.5
			body.look_at(look_pos, Vector3.UP)

		nav.set_velocity(velocity)

	if !alive:
		print("Dead")
		owner.change_state(owner.State.STATE_DEAD)


func _on_NavigationAgent_velocity_computed(safe_velocity):
	if !nav.is_target_reached():
		set_velocity(safe_velocity)
		move_and_slide()
		new_velocity = velocity


func use_skill(skill:int):
	if skill == 1:
		var f = fireball.instantiate()
		add_child(f)


func take_damage(damage:int):
	print("damage recieved")
	health -= damage
	if health < 0:
		alive = false


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if inventory_reference.visible:
			inventory_reference.hide()
		else:
			inventory_reference.show()
