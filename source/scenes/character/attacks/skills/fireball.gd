class_name Fireball
extends Spatial

onready var alive_timer = $alive_timer

var speed:int = 3
var life_time:int = 5
var velocity:Vector3
var direction:Vector3

func _ready():
	set_as_toplevel(true)
	alive_timer.start(life_time)

func _physics_process(delta):
	if direction:
		translation += direction * speed * delta

func _on_alive_timer_timeout():
	queue_free()
