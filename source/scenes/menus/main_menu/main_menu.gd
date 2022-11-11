extends Control


var settings = preload("res://source/scenes/menus/settings/settings.tscn")

func _ready() -> void:
	if OS.has_feature("JavaScript"):
		$HBoxContainer/MarginContainer/VBoxContainer/quit.queue_free()


func _on_play_pressed() -> void:
	SceneManager.emit_signal("change_scene", self, "res://source/scenes/world/world.tscn")


func _on_settings_pressed() -> void:
	var settings_popup = settings.instance()
	self.add_child(settings_popup)


func _on_quit_pressed() -> void:
	get_tree().quit()
