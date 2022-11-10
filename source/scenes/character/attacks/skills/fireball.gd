class_name Fireball
extends Spatial

var speed:int = 1
var life_time:int = 10
var velocity:Vector3

func _init(v:Vector3):
	velocity = v

func _ready():
	pass

func _physics_process(delta):
    transform.origin += velocity * delta

