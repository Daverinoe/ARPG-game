class_name HurtBox
extends Area

func _init() -> void:
    monitorable = false
    collision_mask = 2

func _ready() -> void:
    connect("area_entered", self, "_on_area_entered")


func _on_area_entered(hitbox: HitBox) -> void:
    var method_check = owner.has_method("take_damage")
    if method_check and owner.name != "character":
        owner.take_damage(hitbox.damage)