extends KinematicBody

onready var nav = $NavigationAgent
onready var camera = $sky_camera
onready var navigation = get_parent().get_parent().get_node("Navigation")

var fireball = preload("res://source/scenes/character/attacks/skills/fireball.tscn")

var next_point = Vector3()
var target = Vector3()
var target_position = Vector3()

var velocity = Vector3()
var new_velocity = Vector3()

var movement_speed:int = 6
var health:int = 100
var alive:bool = true

func _ready():
	nav.set_navigation(navigation)

func set_target_position(mouse_position : Vector3):
	if mouse_position != Vector3(0,0,0):
		nav.set_target_location(mouse_position)

func _physics_process(_delta):
	if !nav.is_target_reached():
		next_point = nav.get_next_location()
		var dir = (next_point - global_transform.origin)
		velocity = dir * movement_speed
		velocity.y = 0
		
		nav.set_velocity(velocity)

func _on_NavigationAgent_velocity_computed(safe_velocity):
	if !nav.is_target_reached():
		new_velocity = move_and_slide(safe_velocity)

func use_skill(skill:int):
	if skill == 1:
		print("fire")
		var instance = Fireball.new(new_velocity)
		add_child(instance)

func take_damage(damage:int):
	print("damage recieved")
	health -= damage
	if health < 0:
		alive = false
