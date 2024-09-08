extends CharacterBody3D

@onready var marker_3d = $Pivot/Marker3D

const CANNONBALL_SCENE = preload("res://cannon_minigame/cannonball.tscn")
const MAX_ROTATION_X = 30.0
const MIN_ROTATION_X = -30.0
const MAX_ROTATION_Y = 40.0
const MIN_ROTATION_Y = -40.0

# Variables to store the current rotation
var current_rotation_x = 0.0
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
		current_rotation_x -= 2
		current_rotation_x = clamp(current_rotation_x, MIN_ROTATION_X, MAX_ROTATION_X)
		rotation_degrees.x = current_rotation_x

	if Input.is_action_pressed("move_down"):
		current_rotation_x += 2
		current_rotation_x = clamp(current_rotation_x, MIN_ROTATION_X, MAX_ROTATION_X)
		rotation_degrees.x = current_rotation_x

	if Input.is_action_just_pressed("shoot"):
		_shoot_cannon_ball()
		

func _shoot_cannon_ball():
	var cannonball_node = CANNONBALL_SCENE.instantiate()
	cannonball_node.global_position = marker_3d.global_position
	cannonball_node.linear_velocity = global_basis.z * -30
	get_parent().add_child(cannonball_node)
	cannonball_node.add_to_group("projeteis")	
