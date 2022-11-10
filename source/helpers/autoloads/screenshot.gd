extends Node

# Private constants

const OUTPUT_DIRECTORY: String = "screenshots"
const OUTPUT_FILE_NAME: String = "%04d-%02d-%02d_%02d.%02d.%02d.png"


# Private variables

var activate_prev: bool = false
var activate_curr: bool = true


# Lifecycle methods

func _ready() -> void:
	IOHelper.directory_create(OUTPUT_DIRECTORY)

	self.pause_mode = Node.PAUSE_MODE_PROCESS


func _process(_delta: float) -> void:
	# TODO: Update to input action

	activate_prev = activate_curr
	activate_curr = Input.is_key_pressed(KEY_S)

	var pressed = !activate_prev && activate_curr

	if Input.is_key_pressed(KEY_CONTROL) && Input.is_key_pressed(KEY_SHIFT) && pressed:
		self.screenshot()


# Private methods

func screenshot():
	var capture: Image = self.get_viewport().get_texture().get_data()

	capture.flip_y()

	var datetime: Dictionary = OS.get_datetime(true)
	var file_name: String = OUTPUT_FILE_NAME % [
		datetime["year"],
		datetime["month"],
		datetime["day"],
		datetime["hour"],
		datetime["minute"],
		datetime["second"],
	]

	var capture_result: int = capture.save_png("user://%s/%s" % [OUTPUT_DIRECTORY, file_name])
	if capture_result != OK:
		pass # TODO: Call logger
