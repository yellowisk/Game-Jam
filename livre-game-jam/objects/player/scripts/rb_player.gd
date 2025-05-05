
extends RigidBody3D

@export var jump_velocity = 500
@export var speed = 70
@export var max_speed = 7
@export_range(0.01,1.0) var stop_speed = 0.5

#To get metrics
@export var current_speed = 0.0 
@export var animated_player : Node3D
@export var animation_tree : AnimationTree
@export var dir = Vector3.ZERO
@onready var feet : ShapeCast3D = %Feet

var _last_movement_dir = Vector3.ZERO
var peer_position = Vector3.ZERO
var is_on_floor = false
var move_input = Vector2.ZERO
var colision_normal = Vector3.ZERO
var velocity = Vector3.ZERO
var controlling = null
var on_area = []

func _enter_tree() -> void:
	print("player_enter_tree ", name)
	set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		get_tree().get_first_node_in_group("camera").target = self
		get_tree().get_first_node_in_group("camera").distance_view = 5.0

func _process(delta: float) -> void:
	#State_machine
	animation_tree.set("parameters/conditions/idle", is_on_floor and dir == Vector3.ZERO)
	animation_tree.set("parameters/conditions/jumping", is_on_floor and Input.is_action_just_pressed("jump"))
	animation_tree.set("parameters/conditions/running", is_on_floor and dir.length() > 0.2)
			
	#Rotate body animated
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_dir, Vector3.UP)
	animated_player.global_rotation.y = lerp_angle(animated_player.rotation.y, target_angle, 0.2)

func _physics_process(delta):
	#reset friction to zero to avoid sticking to walk when velocity is applied
	if physics_material_override.friction >= 0:
		physics_material_override.friction = 0
		
	is_on_floor = feet.is_colliding()
	

	if is_multiplayer_authority():
		if not controlling:
			#movement input
			move_input = Input.get_vector("move_left","move_right","move_up", "move_down")
			dir = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
			
			#Jump (Remover)
			if Input.is_action_just_pressed("jump") and is_on_floor:
				#is_on_floor = false
				apply_central_impulse(Vector3.UP * jump_velocity)
		else:
			move_input = Vector2.ZERO
			dir = Vector3.ZERO
		peer_position = global_position
		#Exit Controller
		if Input.is_action_just_pressed("shift"):
			print("shift" + name)
			if controlling:
				leave_control(controlling)
			else:
				for obj in on_area:
					if obj.player_controlling == -1:
						obj.set_player_controlling.rpc(name.to_int())
						controlling = obj
						get_tree().get_first_node_in_group("camera").target = obj
						get_tree().get_first_node_in_group("camera").rotation = obj.rotation
						get_tree().get_first_node_in_group("camera").distance_view = 1.0
						break
	else:
		global_position = lerp(global_position, peer_position, 0.5)
		if peer_position.distance_squared_to(global_position) > 10:
			global_position = peer_position

	if is_on_floor:
		colision_normal = feet.get_collision_normal(0)
		var dir_rotated = (dir.rotated(Vector3(1, 0, 0), asin(colision_normal.z))
						  .rotated(Vector3(0, 0, 1), -asin(colision_normal.x)))
		velocity = dir_rotated * speed
	else:
		velocity = dir * speed

	apply_central_impulse(velocity)
	physics_material_override.friction = 1.0
	
	if dir.length() > 0.2:
		_last_movement_dir = dir
		


	
func _integrate_forces(state):
	#limit max speed
	if state.linear_velocity.length() > max_speed:
		var limit_velocity = state.linear_velocity.normalized() * max_speed
		state.linear_velocity.x = limit_velocity.x
		state.linear_velocity.z = limit_velocity.z

	#artificial stopping movement i.e not using physics
	if move_input.length() < 0.2:
		state.linear_velocity.x = lerp(state.linear_velocity.x, 0.0, stop_speed)
		state.linear_velocity.z = lerp(state.linear_velocity.z, 0.0, stop_speed)
		
	#push against floor to avoid sliding on "unreasonable" slopes
	if state.get_contact_count() > 0 and move_input.length() < 0.2:
		if is_on_floor and state.get_contact_local_normal(0).y < 0.9:
			apply_central_force(-state.get_contact_local_normal(0)*10)
			
	current_speed = state.linear_velocity.length()


func leave_control(obj):
	controlling.set_player_controlling.rpc(-1)
	controlling = null
	get_tree().get_first_node_in_group("camera").target = self
	get_tree().get_first_node_in_group("camera").distance_view = 5.0
	get_tree().get_first_node_in_group("camera").rotation = self.rotation


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group('cannon'):
		body.get_node("AccessMesh").show()
		
	if body is Controllable:
		on_area.append(body)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == controlling:
		leave_control(controlling)
	
	if body.is_in_group('cannon'):
		body.get_node("AccessMesh").hide()
		
	if body is Controllable:
		on_area.erase(body)
