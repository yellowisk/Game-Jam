extends CharacterBody3D

@onready var marker_3d = $Pivot/Marker3D

const CANNONBALL_SCENE = preload("res://scenes/cannon_minigame/cannonball.tscn")
const MAX_ROTATION_Z = 10.0
const MIN_ROTATION_Z = -30.0
const MAX_ROTATION_Y = 125.0
const MIN_ROTATION_Y = 55.0

# Variables to store the current rotation
var current_rotation_z = 0.0
var current_rotation_y = 0.0

func _physics_process(delta: float):
	if Input.is_action_pressed("move_right"):
		current_rotation_y -= 2
		current_rotation_y = clamp(current_rotation_y, MIN_ROTATION_Y, MAX_ROTATION_Y)
		rotation_degrees.y = current_rotation_y

	if Input.is_action_pressed("move_left"):
		current_rotation_y += 2
		current_rotation_y = clamp(current_rotation_y, MIN_ROTATION_Y, MAX_ROTATION_Y)
		rotation_degrees.y = current_rotation_y

	if Input.is_action_pressed("move_up"):
		current_rotation_z += 1
		current_rotation_z = clamp(current_rotation_z, MIN_ROTATION_Z, MAX_ROTATION_Z)
		$"canhão/Cannon".rotation_degrees.z = current_rotation_z

	if Input.is_action_pressed("move_down"):
		current_rotation_z -= 1
		current_rotation_z = clamp(current_rotation_z, MIN_ROTATION_Z, MAX_ROTATION_Z)
		$"canhão/Cannon".rotation_degrees.z = current_rotation_z

	if Input.is_action_just_pressed("shoot"):
		var projeteis = get_tree().get_nodes_in_group("projeteis")
		print(projeteis)
		_shoot_cannon_ball()

func _shoot_cannon_ball():
	var cannonball_node = CANNONBALL_SCENE.instantiate()
	cannonball_node.position = Vector3(0, 0, 0)
	cannonball_node.linear_velocity = ($"canhão/Cannon/Marker3D".position - cannonball_node.position).normalized() * 20
	add_child(cannonball_node)
	
	cannonball_node.add_to_group("projeteis")
