extends Spatial

var health:int = 10
var alive:bool = true

func _ready():
	pass

func _process(_delta):
	if !alive:
		queue_free()


func take_damage(damage:int):
	health -= damage
	if health < 0:
		alive = false
	