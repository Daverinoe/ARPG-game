extends Spatial

onready var character = get_node("character")
onready var sky_camera = get_node("character/sky_camera")

func _ready():
	pass

func _process(_delta):
	#print(get_parent().current_state)
	pass

func _input(event):
	var state = owner.current_state
	if event is InputEventMouseMotion:
		if state == owner.State.STATE_MOVE:
			if character.moving:
				character.set_target_position(screen_point_to_ray(get_viewport().get_mouse_position()))
	if event.is_action_pressed("left_click"):
		if state == owner.State.STATE_MOVE:
			character.set_target_position(screen_point_to_ray(event.position))
			character.moving = true
	if event.is_action_released("left_click"):
		if state == owner.State.STATE_MOVE:
			character.moving = false
			character.clear_target_position()
	if event.is_action_pressed("skill_one"):
		if state == owner.State.STATE_MOVE:
			character.use_skill(1)
	if event.is_action_pressed("right_click"):
		Event.emit_signal("drop_loot", 30, character.global_translation)


func screen_point_to_ray(pos):
	var space_state = get_world().direct_space_state
	var ray_origin = sky_camera.project_ray_origin(pos)
	var ray_end = ray_origin + sky_camera.project_ray_normal(pos) * 2000
	var ray_array = space_state.intersect_ray(ray_origin, ray_end)

	if ray_array.has("position"):
		return ray_array["position"]
	return Vector3()
