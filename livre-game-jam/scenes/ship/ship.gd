extends RigidBody3D

@export var float_force := 2.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05
@export var reset_duration := 2.0

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal wheel_flag

const water_height := 0.0

var submerged := false
var player_controlled = false
var once = true

var target_position := Vector3(0, 0, 0)  # Where the ship should return to
var resetting := false  # To track if the reset is in progress
var reset_timer := 0.0  # Timer to smoothly interpolate back
var player_curr = null

func rotate_ship():
	if Input.is_action_pressed("move_right"):
		angular_velocity += Vector3(0.02, 0, 0)
	elif Input.is_action_pressed("move_left"):
		angular_velocity += Vector3(-0.02, 0, 0)
	else:
		pass
	#if the degrees of rotation are greater than 90, reset the rotation

# Process function to handle ship rotation and resetting
func _process(delta: float) -> void:
	if player_controlled:
		rotate_ship()


# This function resets the ship after a delay
func reset_ship_after_delay() -> void:
	await get_tree().create_timer(6).timeout
	resetting = true  
	reset_timer = 0.5
	player_controlled = false  
	once = true
	$"/root/Main/MinigameController".finished_timao.emit()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if resetting:
		# Gradually return to the original position
		reset_timer += delta / reset_duration
		global_rotation = global_rotation.slerp(Vector3(0, 0, 0), reset_timer)
		
		if reset_timer >= 1.0:
			resetting = false  # Stop resetting once done
			position = Vector3(0, 0, 0)
			linear_velocity = Vector3(0, 0, 0)
			angular_velocity = Vector3(0, 0, 0)
			rotation = Vector3(0, 0, 0)
			

	var depth = water_height - global_position.y
	if depth > 0:
		apply_central_force(Vector3.UP * float_force * gravity * depth)
		
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if submerged:
		state.linear_velocity.y *= 1 - water_drag
		state.angular_velocity.y *= 1 - water_angular_drag

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
