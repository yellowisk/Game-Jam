
extends RigidBody3D

@export var jump_velocity = 500
@export var acceleration = 5
@export var speed = 70
@export var max_speed = 7
@export_range(0.01,1.0) var stop_speed = 0.5
@export var view_sensitivity = 10.0
@export var current_speed = 0.0

var accel_multiplier = 1.0
var velocity=Vector3()
var mouse_input = Vector2()

@onready var head = $CameraPivot
@onready var eyes = $CameraPivot/SpringArm3D/Camera3D
@onready var body = $Body
@onready var feet = %Feet
@onready var feet_detector = %Feet/RayCast3D

var is_on_floor = false
var move_input = Vector2.ZERO

func _ready():
	linear_damp = 1.0
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	#reset friction to zero to avoid sticking to walk when velocity is applied
	if physics_material_override.friction >= 0:
		physics_material_override.friction = 0
	is_on_floor = false
	move_input = Vector2.ZERO
	var dir = Vector3()
	#movement input
	move_input = Input.get_vector("move_left","move_right","move_up", "move_down")
	dir = (transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
	var dir_rotated = dir.rotated(Vector3(1, 0, 0), feet.rotation.x).rotated(Vector3(0, 0, 1), feet.rotation.z)
	velocity = dir_rotated * speed

	
	if feet_detector.is_colliding():
		apply_central_impulse(velocity)
		is_on_floor = true
		physics_material_override.friction = 1.0
		accel_multiplier = 1.0
	if Input.is_action_just_pressed("jump") and is_on_floor:
		accel_multiplier = 0.1
		is_on_floor = false
		apply_central_impulse(Vector3.UP * jump_velocity)
	mouse_input =Vector2.ZERO
	

func _integrate_forces(state):
	#limit max speed
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized()*max_speed
	#artificial stopping movement i.e not using physics
	if move_input.length() < 0.2:
		state.linear_velocity.x = lerp(state.linear_velocity.x,0.0,stop_speed)
		state.linear_velocity.z = lerp(state.linear_velocity.z,0.0,stop_speed)
	#push against floor to avoid sliding on "unreasonable" slopes
	if state.get_contact_count() > 0 and move_input.length()< 0.2:
		if is_on_floor and state.get_contact_local_normal(0).y < 0.9:
			apply_central_force(-state.get_contact_local_normal(0)*10)
			
	current_speed = state.linear_velocity.length()

#mouse input
func _input(event):
	if event is InputEventMouseMotion:
		mouse_input = event.relative;
