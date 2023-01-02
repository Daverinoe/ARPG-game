class_name HitBox
extends Area3D

var damage:int

func _init(d: int = 10):
    damage = d
    collision_mask = 0
    collision_layer = 2