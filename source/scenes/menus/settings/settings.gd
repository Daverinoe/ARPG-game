extends Control


func _on_back_pressed() -> void:
	SettingsManager.settings_save()
	self.queue_free()
