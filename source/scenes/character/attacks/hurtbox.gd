class_name HurtBox
extends Area

func _init() -> void:
    monitorable = false
    collision_mask = 2

func _ready() -> void:
    connect("area_entered", self, "_on_area_entered")


func _on_area_entered(hitbox: HitBox) -> void:
    if owner.has_method("take damage"):
        owner.take_damage(hitbox.damage)