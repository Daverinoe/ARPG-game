extends Node2D

var sprite_file : StreamTexture
onready var sprite_ref : Sprite = $item_sprite

func _ready() -> void:
	yield(get_parent(), "ready")
	sprite_ref.texture = sprite_file

func _process(delta: float) -> void:
	self.global_position = get_global_mouse_position()
