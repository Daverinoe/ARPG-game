extends Node

# Emit this signal to switch between scenes.
signal change_scene(scene1, scene_path)
signal finished_loading()

var resource_loader : ResourceInteractiveLoader
var total_stages : int = 0
var new_instance = null
var finished_loading

onready var bar_reference : TextureProgress = $VBoxContainer/MarginContainer/loading_progress


func _ready() -> void:
	set_process(false)
	self.visible = false
	connect("change_scene", self, "switch_scenes")


func _process(delta):
	# Check load progress and update progress bar
	var error_code = resource_loader.poll()
	if error_code == ERR_FILE_EOF:
		bar_reference.value = 100
		emit_signal("finished_loading")
	elif error_code == OK:
		var current_stage = resource_loader.get_stage()
		var current_progress = current_stage / total_stages * 100
		bar_reference.value = current_progress
	else:
		push_error("Loading new scene failed!")


func _input(event):
	if finished_loading and !(event is InputEventMouseMotion):
		finish_switch()


func switch_scenes(previous_scene_reference, next_scene_path) -> void:
	self.visible = true
	# Fade in loading scene
	tween_load_visibility(0, 1.0)
	
	# Remove old scene
	previous_scene_reference.queue_free() # NOTE: Add in save state here, if needed.
	
	# Load new scene
	resource_loader = ResourceLoader.load_interactive(next_scene_path)
	total_stages = resource_loader.get_stage_count()
	set_process(true)
	
	yield(self, "finished_loading")
	finished_loading = true
	set_process(false)
	
	# Instance new scene
	var new_scene = resource_loader.get_resource()
	new_instance = new_scene.instance()
	new_instance.set_process(false)
	new_instance.visible = false
	get_tree().root.add_child(new_instance)
	
	$VBoxContainer/hint.text = "Press any key to continue."


func tween_load_visibility(start_alpha, final_alpha) -> void:
	var tween = get_tree().create_tween()
	var property_tweener : PropertyTweener = tween.tween_property(
		self,
		"modulate",
		Color(1.0, 1.0, 1.0, final_alpha),
		0.5
	)
	
	property_tweener.from(Color(1.0, 1.0, 1.0, start_alpha))
	tween.play()
	yield(tween, "finished")


func finish_switch() -> void:
	new_instance.visible = true
	# Fade out loading scene
	tween_load_visibility(1.0, 0.0)
	self.visible = false
	new_instance.set_process(true)
	new_instance = null
	finished_loading = false
	yield(get_tree().create_timer(0.2), "timeout")
	Global.can_control = true
