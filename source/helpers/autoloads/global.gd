extends Node

var can_control : bool = true

var target_position : Vector3 = Vector3()


# References
onready var level_reference = get_tree().root
var LootManager
var camera_reference
var player_reference
