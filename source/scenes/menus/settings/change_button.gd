class_name ChangeButton extends BoardButton


# Public variables

export(String) var binding: String


# Private methods

var current: int = 0
var listening: bool = false


# Lifecycle methods

func _ready() -> void:
	self.current = InputManager.get_key(self.binding)
	self.update_text()

	self.connect("focus_exited", self, "focus_exited")
	self.connect("pressed", self, "pressed")


func _input(event: InputEvent) -> void:
	if self.listening && event is InputEventKey && event.pressed:
		self.update_text_color(Color.white)

		var incoming: int = event.scancode

		if incoming == self.current:
			self.get_tree().set_input_as_handled()
			self.listening = false
			self.update_text()
			return

		if InputManager.is_used(incoming):
			self.get_tree().set_input_as_handled()
			self.update_text_color(Color("#b1385c"))
			self.update_text(incoming)
			return

		SettingsManager.set_setting(self.binding, incoming)

		self.current = incoming
		self.listening = false
		self.update_text()
		self.get_tree().set_input_as_handled()


# Private methods

func focus_exited() -> void:
	self.listening = false
	self.update_text()
	self.update_text_color(Color.white)


func pressed() -> void:
	self.listening = true
	self.text = "..."


func update_text(override: int = -1) -> void:
	var value: int = self.current

	if override != -1:
		value = override

	self.text = OS.get_scancode_string(value)

func update_text_color(color: Color) -> void:
	self.add_color_override("font_color", color)
	self.add_color_override("font_color_focus", color)
	self.add_color_override("font_color_hover", color)
