extends Controllable

@onready var cannon = $Body/Cannon
@onready var timer = $Timer

const CANNONBALL_SCENE = preload("res://objects/cannon/scenes/cannonball.tscn")
const MAX_ROTATION_Z = 45.0
const MIN_ROTATION_Z = -5.0
const MAX_ROTATION_Y = 45.0

@onready var start_y = rotation_degrees.y

@export var shoot_power := 40.0
@export var sens_horizontal := 1.0
@export var sens_vertical := 0.5

@onready var rot = rotation_degrees

var can_shoot = true


func _process(_delta: float):
	#print(player_controlling, " ", multiplayer.get_unique_id())
	if player_controlling != multiplayer.get_unique_id():
		return;
	
	
	if Input.is_action_pressed("move_right"):
		rot.y = clamp(rotation_degrees.y - sens_horizontal, -MAX_ROTATION_Y + start_y, MAX_ROTATION_Y + start_y)

	if Input.is_action_pressed("move_left"):
		rot.y = clamp(rotation_degrees.y + sens_horizontal, -MAX_ROTATION_Y + start_y, MAX_ROTATION_Y + start_y)

	if Input.is_action_pressed("move_up"):
		rot.x = clamp(cannon.rotation_degrees.x + sens_vertical, MIN_ROTATION_Z, MAX_ROTATION_Z)

	if Input.is_action_pressed("move_down"):
		rot.x = clamp(cannon.rotation_degrees.x - sens_vertical, MIN_ROTATION_Z, MAX_ROTATION_Z)

	move_cannon.rpc_id(1, rot)
	if Input.is_action_just_pressed("shoot") and can_shoot:
		can_shoot = false
		_shoot_cannon_ball.rpc()
		timer.start(1.2)

@rpc("any_peer", "call_local")
func _shoot_cannon_ball():
	var cannonball_node = CANNONBALL_SCENE.instantiate()
	get_tree().get_root().add_child(cannonball_node)
	cannonball_node.global_position = %ShootPos.global_position
	#print(global_basis)
	#cannonball_node.linear_velocity = Vector3.FORWARD * shoot_power
	#cannonball_node.global_basis = global_basis
	#cannonball_node.apply_central_impulse(basis.z.rotated(Vector3.RIGHT, cannon.rotation.x) * shoot_power)
	cannonball_node.linear_velocity = -global_basis.z.rotated(Vector3.RIGHT, cannon.global_rotation.x) * shoot_power
	#cannonball_node.linear_velocity = %ShootPos.basis.z * shoot_power

@rpc("any_peer", "call_local")
func move_cannon(rot):
	rotation_degrees.y = rot.y
	cannon.rotation_degrees.x = rot.x
	
func _on_timer_timeout() -> void:
	can_shoot = true
