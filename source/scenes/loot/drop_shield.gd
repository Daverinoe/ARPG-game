extends Sprite3D

onready var label : Label3D = $item_name
onready var click_area : Area = $click_shield

var base_texture : ImageTexture = ImageTexture.new()

var common_modulate : Color = Color(0.5, 0.5, 0.5, 0.5)
var magic_modulate : Color = Color(0.3, 0.3, 0.7, 0.5)
var unique_modulate : Color = Color(1, 0.843, 0.0, 0.5)
var base_modulate : Color
var min_size : Vector2

func _ready():
	var item_name : String= get_parent().item_name
	label.text = item_name
	
	# Attempt to set back-shield texture to correct size
	create_and_set_texture(item_name)
	set_collision_shape_extents()
	match get_parent().get_parent().rarity:
		0:
			base_modulate = common_modulate
		1:
			base_modulate = magic_modulate
		2:
			base_modulate = unique_modulate
	
	self.modulate = base_modulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var global_position = get_parent().global_translation
	self.global_translation = global_position + Vector3(0.0, 2.0, 0.0)
#	get_child(0).global_translation = global_position + Vector3(0.0, 2.0, 0.0)
	
	
	# Ensure click area is always facing the camera, and the size is correct
	click_area.look_at(Global.camera_reference.global_translation, Vector3.UP)


func pt_to_px(pt_size : int) -> float:
	# 1 pt is equal to 1.3 pixels
	return pt_size * 1.3


func create_and_set_texture(item_name) -> void:
	var label_font_size : int = 40
	var font_size_in_pixels : float = pt_to_px(label_font_size)
	var num_chars = item_name.length()
	min_size = Vector2(num_chars * (font_size_in_pixels / 1.6), font_size_in_pixels + 10)
	
	var image : Image = Image.new()
	image.create(min_size.x, min_size.y, false, Image.FORMAT_RGBA8)
	
	image.lock()
	for x in range(min_size.x):
		for y in range(min_size.y):
			image.set_pixel(x, y, Color(1.0, 1.0, 1.0, 1.0))
	
	image.unlock()
	
	base_texture.create_from_image(image)
	self.texture = base_texture


func _on_click_shield_mouse_entered() -> void:
	self.modulate.a += 0.5


func _on_click_shield_mouse_exited() -> void:
	self.modulate.a -= 0.5


func set_collision_shape_extents() -> void:
	var new_box_shape = BoxShape.new()
	new_box_shape.extents = Vector3(min_size.x, min_size.y, 1.0)/200.0
	click_area.get_child(0).shape = new_box_shape
