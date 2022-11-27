extends RigidBody

var collision_shape : CollisionShape
var mesh : MeshInstance
var drop_position : Vector3
var item_scene : PackedScene

var item_name : String

func _enter_tree():
	item_name = get_parent().item_name
	

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
	set_static(false)
	get_tree().create_timer(3).connect("timeout", self, "set_static", [true])
	
	
	# Apply "drop" rotations
	self.linear_velocity = Vector3.ZERO
	self.angular_velocity = Vector3.ZERO
	self.apply_impulse(Vector3.ZERO, Vector3(rand_range(-5.0, 5.0), rand_range(5.0, 8.0), rand_range(-5.0, 5.0)))
	self.apply_torque_impulse(Vector3(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)) * 1.0)
	
	# Reset drop shield back color
	$drop_shield._on_click_shield_mouse_exited()


func set_static(_is_static : bool) -> void:
	self.sleeping = _is_static
	if  _is_static:
		self.mode = RigidBody.MODE_STATIC
		self.set_collision_layer(0)
		self.set_collision_mask(0)
	else:
		self.mode = RigidBody.MODE_RIGID
		self.set_collision_layer(4)
		self.set_collision_mask(2)
