
extends RigidBody3D

@export var jump_velocity = 500
@export var speed = 70
@export var max_speed = 7
@export_range(0.01,1.0) var stop_speed = 0.5
@export var current_speed = 0.0 #To get metrics
@export var animated_player : Node3D
@onready var feet : ShapeCast3D = %Feet

var accel_multiplier = 1.0
var velocity = Vector3.ZERO
var _last_movement_dir = Vector3.ZERO
var peer_position = Vector3.ZERO
var peer_rotation = Vector3.ZERO
var is_on_floor = false
var move_input = Vector2.ZERO

func _enter_tree() -> void:
	print("player_enter_tree ", name)
	set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		get_tree().get_first_node_in_group("camera").target = self

func _physics_process(delta):
	if is_multiplayer_authority():
		#reset friction to zero to avoid sticking to walk when velocity is applied
		if physics_material_override.friction >= 0:
			physics_material_override.friction = 0
		var dir = Vector3()
		
		if is_multiplayer_authority():
			#movement input
			is_on_floor = false
			move_input = Vector2.ZERO
			move_input = Input.get_vector("move_left","move_right","move_up", "move_down")
		dir = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
		var colision_normal = Vector3.ZERO
		if feet.is_colliding():
			colision_normal = feet.get_collision_normal(0)
			
		var dir_rotated = (dir.rotated(Vector3(1, 0, 0), asin(colision_normal.z))
							  .rotated(Vector3(0, 0, 1), -asin(colision_normal.x)))
							
		velocity = dir_rotated * speed
		
		if dir.length() > 0.2:
			_last_movement_dir = dir
			
		var target_angle := Vector3.BACK.signed_angle_to(_last_movement_dir, Vector3.UP)
		animated_player.global_rotation.y = lerp_angle(animated_player.rotation.y, target_angle, 2.0 * delta)
		peer_rotation = animated_player.global_rotation
		
		if feet.is_colliding():
			apply_central_impulse(velocity)
			is_on_floor = true
			physics_material_override.friction = 1.0
			accel_multiplier = 1.0
		if Input.is_action_just_pressed("jump") and is_on_floor:
			accel_multiplier = 0.1
			is_on_floor = false
			apply_central_impulse(colision_normal * jump_velocity)
		peer_position = global_position
	else:
		global_position = lerp(global_position, peer_position, 0.2)
		if peer_position.distance_squared_to(global_position) > 10:
			global_position = peer_position
		animated_player.rotation = lerp(animated_player.rotation, peer_rotation, 0.5)

	
func _integrate_forces(state):
	if is_multiplayer_authority():
		#limit max speed
		if state.linear_velocity.length() > max_speed:
			state.linear_velocity = state.linear_velocity.normalized() * max_speed
		
		#artificial stopping movement i.e not using physics
		if move_input.length() < 0.2:
			state.linear_velocity.x = lerp(state.linear_velocity.x, 0.0, stop_speed)
			state.linear_velocity.z = lerp(state.linear_velocity.z, 0.0, stop_speed)
			
		#push against floor to avoid sliding on "unreasonable" slopes
		if state.get_contact_count() > 0 and move_input.length() < 0.2:
			if is_on_floor and state.get_contact_local_normal(0).y < 0.9:
				apply_central_force(-state.get_contact_local_normal(0)*10)
				
		current_speed = state.linear_velocity.length()
