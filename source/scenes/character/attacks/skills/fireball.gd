class_name Fireball
extends Node3D

@onready var alive_timer = $alive_timer

var speed:int = 25
var life_time:int = 5
var velocity:Vector3

func _ready():
	set_as_top_level(true)
	alive_timer.start(life_time)

func _physics_process(delta):
	position -= transform.basis.z * speed * delta

func _on_alive_timer_timeout():
	queue_free()
