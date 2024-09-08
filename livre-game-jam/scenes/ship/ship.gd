extends RigidBody3D

@export var float_force := 2.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05
@export var reset_duration := 2.0

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal wheel_flag

const water_height := 0.0

var submerged := false
var is_on_wheel = false
var once = true

var target_position := Vector3(0, 0, 0)  # Where the ship should return to
var resetting := false  # To track if the reset is in progress
var reset_timer := 0.0  # Timer to smoothly interpolate back
var player_curr = null

func rotate_ship():
	if Input.is_action_pressed("move_right"):
		angular_velocity = Vector3(2, 0, 0)
	elif Input.is_action_pressed("move_left"):
		angular_velocity = Vector3(-2, 0, 0)
	else:
		pass
	#if the degrees of rotation are greater than 90, reset the rotation

# Process function to handle ship rotation and resetting
func _process(delta: float) -> void:
	get_tree().call_group("timao", "on_body_entered")
	if is_on_wheel:
		if once:
			var vels = [-1,1]
			angular_velocity = Vector3(vels[randi_range(0,1)], 0, 0)
			once = false
		
		rotate_ship()

		if not resetting:
			call_deferred("reset_ship_after_delay")

# This function resets the ship after a delay
func reset_ship_after_delay() -> void:
	resetting = true  
	reset_timer = 0.5
	is_on_wheel = false  
	once = true  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if rotation_degrees.x > 45:
		angular_velocity = Vector3(-1, 0, 0)
	elif rotation_degrees.x < -45:
		angular_velocity = Vector3(1, 0, 0)
	
	if resetting:
		# Gradually return to the original position
		reset_timer += delta / reset_duration
		global_position = global_position.lerp(target_position, reset_timer)
		global_rotation = global_rotation.slerp(Vector3(0, 0, 0), reset_timer)
		
		if reset_timer >= 1.0:
			resetting = false  # Stop resetting once done
			is_on_wheel = false
			

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


func _on_wheel_flag(player):
	is_on_wheel = true
	get_parent().stop_player_flag.emit(player.name)
	player_curr = player
	return player.name
