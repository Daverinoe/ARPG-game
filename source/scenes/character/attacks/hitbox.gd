class_name HitBox
extends Area

var damage:int

func _init(d: int = 10) -> void:
    damage = d
    collision_mask = 0
    collision_layer = 2