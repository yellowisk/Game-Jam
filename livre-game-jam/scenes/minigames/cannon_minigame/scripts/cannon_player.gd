extends CharacterBody3D

@onready var start_rotation_z = $"canhão/Cannon".rotation_degrees.z
@onready var start_rotation_y = $"canhão/Cannon".rotation_degrees.y

const CANNONBALL_SCENE = preload("res://scenes/minigames/cannon_minigame/cannonball.tscn")
const MAX_ROTATION_Z = 10.0
const MIN_ROTATION_Z = -30.0
const MAX_ROTATION_Y = 125.0
const MIN_ROTATION_Y = 55.0

var CAN_SHOOT = true

func _physics_process(_delta: float):
	if Input.is_action_pressed("move_right"):
		rotation_degrees.y = clamp(rotation_degrees.y - 1.5, MIN_ROTATION_Y + start_rotation_y, MAX_ROTATION_Y + start_rotation_y)

	if Input.is_action_pressed("move_left"):
		rotation_degrees.y = clamp(rotation_degrees.y + 1.5,  MIN_ROTATION_Y + start_rotation_y, MAX_ROTATION_Y + start_rotation_y)

	if Input.is_action_pressed("move_up"):
		$"canhão/Cannon".rotation_degrees.z = clamp($"canhão/Cannon".rotation_degrees.z + 1, MIN_ROTATION_Z + start_rotation_z, MAX_ROTATION_Z + start_rotation_y)

	if Input.is_action_pressed("move_down"):
		$"canhão/Cannon".rotation_degrees.z = clamp($"canhão/Cannon".rotation_degrees.z - 1, MIN_ROTATION_Z + start_rotation_z, MAX_ROTATION_Z + start_rotation_y)

	if Input.is_action_just_pressed("shoot") and CAN_SHOOT:
		CAN_SHOOT = false
		_shoot_cannon_ball()
		await get_tree().create_timer(1.2).timeout
		CAN_SHOOT = true

func _shoot_cannon_ball():
	var cannonball_node = CANNONBALL_SCENE.instantiate()
	get_parent().add_child(cannonball_node)
	cannonball_node.global_position = $"canhão/Cannon".global_position
	print($"canhão/Cannon".rotation_degrees.z - start_rotation_z)
	cannonball_node.linear_velocity = global_basis.x.rotated(global_basis.z, deg_to_rad($"canhão/Cannon".rotation_degrees.z - start_rotation_z)) * 22
	
	cannonball_node.add_to_group("projeteis")
