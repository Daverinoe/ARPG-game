extends Node

signal set_ss_shader


func set_graphic(name: String, value) -> void:
	match name:
		"screen_resolution":
			change_resolution(value)
		"fullscreen":
			set_fullscreen(value)
		"colorblind":
			set_colorblind(value)
		"colorblind_intensity":
			set_colorblind_intensity(value)
		_:
			push_warning("Option doesn't exist.")
			pass

func change_resolution(value: String) -> void:
	var res_vals = value.split("x")
	var resolution = Vector2(str2var(res_vals[0]), str2var(res_vals[1]))
	OS.set_window_size(resolution)


func set_fullscreen(value: bool) -> void:
	OS.window_fullscreen = value


func set_colorblind(value: int) -> void:
	emit_signal("set_ss_shader")


func set_colorblind_intensity(value: float) -> void:
	emit_signal("set_ss_shader")
