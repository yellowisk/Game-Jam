extends RigidBody3D

@export var anim_skel: Skeleton3D
@export var anim_body: Node3D

const SPEED = 10
const JUMP_STRENGTH = 70
const ANGULAR_ACELERATION = 7
const ANGULAR_DESACELERATION = 0.1
const SPEED_DESACELERATION = 0.1

const DAMPING = 0.9

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_dir = Vector2.ZERO

func _ready():
	axis_lock_angular_y = true
	
func update_animation_parameters():
	if input_dir == Vector2.ZERO:
		anim_tree["parameters/conditions/idle"] = true
		anim_tree["parameters/conditions/is_moving"] = false
	else:
		anim_tree["parameters/conditions/idle"] = false
		anim_tree["parameters/conditions/is_moving"] = true
	if Input.is_action_just_pressed("jump"):
		anim_tree["parameters/conditions/jump"] = true
	else:
		anim_tree["parameters/conditions/jump"] = false
	
func _physics_process(delta):
	rotation.x = move_toward(rotation.x, 0, ANGULAR_DESACELERATION)
	rotation.z = move_toward(rotation.z, 0, ANGULAR_DESACELERATION)
	input_dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if on_floor.is_colliding():
		if direction != Vector3.ZERO:
			linear_velocity.x = direction.x * SPEED
			linear_velocity.z = direction.z * SPEED
		else:
			linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED)
			linear_velocity.z = move_toward(linear_velocity.z, 0, SPEED)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, SPEED_DESACELERATION)
		linear_velocity.z = move_toward(linear_velocity.z, 0, SPEED_DESACELERATION)

	update_animation_parameters()
	anim_body.rotation.y = lerp_angle(anim_body.rotation.y, atan2(input_dir.x, input_dir.y), delta * ANGULAR_ACELERATION)
