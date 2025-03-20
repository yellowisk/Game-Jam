extends RigidBody3D

@export var jump_force := 10.0
@export_range(0, 1) var air_drag := 0.01
@export_range(0, 1) var air_angular_drag := 0.01
@export var speed := 10.0

@onready var ground_raycast: RayCast3D = $GroundPoint
var direction := Vector2.ZERO
var is_on_ground := false
var moviment := Vector2.ZERO

func _process(delta):
	pass
	
# Called when the node enters the scene tree for the first time.
func _physics_process(delta: float) -> void:
		pass
		

func _integrate_forces(state: PhysicsDirectBodyState3D):
	is_on_ground = ground_raycast.is_colliding()
	direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")).normalized()
	#if direction != Vector2.ZERO:
	moviment = direction * speed
	#else:
		#moviment.x = move_toward(moviment.x, 0, speed)
		#moviment.y = move_toward(moviment.y, 0, speed)
	if is_on_ground:
		if Input.is_action_just_pressed("jump") and is_on_ground:
			state.linear_velocity.y += jump_force
		if abs(moviment.x) > abs(state.linear_velocity.x):
			state.linear_velocity.x = moviment.x
		if abs(moviment.y) > abs(state.linear_velocity.z):	
			state.linear_velocity.z = moviment.y
			
		if Input.is_action_just_released("move_right") or  Input.is_action_just_released("move_left"):
			state.linear_velocity.x = moviment.x
		if Input.is_action_just_released("move_up") or Input.is_action_just_released("move_down"):
			state.linear_velocity.z = moviment.y
			
	state.linear_velocity *=  1 - air_drag
	state.angular_velocity *= 1 - air_angular_drag 
