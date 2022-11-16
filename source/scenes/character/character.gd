extends KinematicBody

export var fireball: PackedScene

onready var nav = $NavigationAgent
onready var camera = $sky_camera
onready var navigation = owner.get_node("Navigation")
onready var body = $CSGCylinder

var next_point = Vector3()
var target = Vector3()
var target_position = Vector3()

var velocity = Vector3()
var new_velocity = Vector3()

var movement_speed:int = 8
var health:int = 100
var alive:bool = true
var moving:bool = false
var movement_held:bool = false

func _ready():
	nav.set_navigation(navigation)

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
			body.look_at(translation + dir, Vector3.UP)

		nav.set_velocity(velocity)

	if !alive:
		print("Dead")
		owner.change_state(owner.State.STATE_DEAD)

func _on_NavigationAgent_velocity_computed(safe_velocity):
	if !nav.is_target_reached():
		new_velocity = move_and_slide(safe_velocity)

func use_skill(skill:int):
	if skill == 1:
		var f = fireball.instance()
		add_child(f)

func take_damage(damage:int):
	print("damage recieved")
	health -= damage
	if health < 0:
		alive = false
