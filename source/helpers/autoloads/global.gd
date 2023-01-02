extends Node

var can_control : bool = false

var target_position : Vector3 = Vector3()

# Inventory constants
var inventory_slot_size : int = 50


# References
@onready var level_reference = get_tree().root
var character_reference
var LootManager
var camera_reference
var player_reference
