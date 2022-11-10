extends Spatial

var health:int = 10
var alive:bool = true

func _ready():
	pass

func _process(_delta):
	if !alive:
		owner.queue_free()


func take_damage(damage:int):
	print("damage recieved")
	health -= damage
	if health < 0:
		alive = false
	