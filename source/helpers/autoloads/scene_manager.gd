extends Node

# Seems to be broken in 3.5, so adding manually
export ( Array, Resource ) onready var scenes = [
	preload("res://source/scenes/menus/main_menu/main_menu.tscn"),
	preload("res://source/scenes/main/main.tscn")
]

var scenes_by_name = {}


# Lifecycle methods
func _ready() -> void:
	for scene in self.scenes:
		var scene_name: String = scene.get_state().get_node_name(0)
		self.scenes_by_name[scene_name] = scene

# Public methods
func load_scene(name: String) -> void:
	if name in self.scenes_by_name:
		self.get_tree().change_scene_to(self.scenes_by_name[name])
	else:
		push_error("Could not load scene with name: %s" % name)
