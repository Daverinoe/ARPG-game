extends RigidBody

var collision_shape : CollisionShape
var mesh : MeshInstance
var drop_position : Vector3
var is_static : bool = false
var item_scene : PackedScene

var item_name : String

func _enter_tree():
	item_name = get_parent().item_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# We don't want items to move after coming to a stop, so after sleep, change collision
	# detection to nothing and set MODE to static
	if is_static and sleeping:
		self.mode = RigidBody.MODE_STATIC
		self.set_collision_layer(0)
		self.set_collision_mask(0)
	

func drop() -> void:
	# We want to instance the item mesh, but it comes under a spatial node
	# So we want to extract the mesh by itself
	if mesh == null and collision_shape == null:
		var item_mesh_scene = item_scene.instance()
		mesh = item_mesh_scene.get_child(0)
		item_mesh_scene.remove_child(mesh)
		self.call_deferred("add_child", mesh)

		# get_child only needs 0 here because we've already removed the only other child
		var collision_shape = item_mesh_scene.get_child(0)
		item_mesh_scene.remove_child(collision_shape)
		self.call_deferred("add_child", collision_shape)
		item_mesh_scene.free()
	
	self.global_translation = drop_position + Vector3(0.0, 1.0, 0.0)
	self.sleeping = false
	set_static(false)
	get_tree().create_timer(1).connect("timeout", self, "set_static", [true])
	
	
	# Apply "drop" rotations
	self.apply_impulse(Vector3.ZERO, Vector3(rand_range(0.0, 5.0), 8.0, rand_range(0.0, 5.0)))
	self.apply_torque_impulse(Vector3(4.0, 1.0, 2.0) * 10.0)

func set_static(_is_static : bool) -> void:
	is_static = _is_static
