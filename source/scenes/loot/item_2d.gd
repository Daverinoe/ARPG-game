extends Control

var sprite_file : CompressedTexture2D
@onready var sprite_ref : TextureRect = $item_background/MarginContainer/item_texture
@onready var sprite_background_ref : TextureRect = $item_background

var base_texture : ImageTexture = ImageTexture.new()
var base_modulate : Color

var item_ref : ItemDrop
var size_2d : Vector2

func _ready() -> void:
	item_ref = get_parent()
	
	# Attempt to set back texture to correct size
	match get_parent().rarity:
		0:
			base_modulate = Item.common_modulate
		1:
			base_modulate = Item.magic_modulate
		2:
			base_modulate = Item.unique_modulate
	
	sprite_background_ref.modulate = base_modulate
	
	await item_ref.ready
	size_2d = set_size_2d()
	self.custom_minimum_size = size_2d
	set_sprite()
	create_and_set_texture()


func _process(delta: float) -> void:
	self.global_position = get_global_mouse_position()


func set_size_2d() -> Vector2:
	var inv_size = item_ref.inventory_size
	var slot_size = Global.inventory_slot_size
	return inv_size * slot_size


func create_and_set_texture() -> void:
	var min_size = size_2d
	
	var image : Image = Image.create(min_size.x, min_size.y, false, Image.FORMAT_RGBA8)
	
	for x in range(min_size.x):
		for y in range(min_size.y):
			image.set_pixel(x, y, Color(1.0, 1.0, 1.0, 1.0))

	
	base_texture.create_from_image(image)
	sprite_background_ref.texture = base_texture


func place_down(new_position: Vector2) -> void:
	self.global_position = new_position


func set_sprite() -> void:
#	sprite_ref.expand = true
	sprite_ref.stretch_mode = TextureRect.STRETCH_SCALE
	sprite_ref.texture = sprite_file
	sprite_ref.custom_minimum_size = size_2d - Vector2(10, 10)
	sprite_ref.size = size_2d - Vector2(10, 10)
