extends CharacterBody3D

@export var anim_tree: AnimationTree
@export var physical_bone_body : PhysicalBone3D
@export var on_floor_left : ShapeCast3D
@export var on_floor_right : ShapeCast3D
@export var on_floor : RayCast3D


@export var anim_skel: Skeleton3D
@export var anim_body: Node3D

const SPEED = 5
const JUMP_VELOCITY = 5
const ANGULAR_ACELERATION = 7
const DAMPING = 0.9

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var input_dir = Vector2.ZERO

func _ready():
	anim_tree.active = true

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
	if not on_floor.is_colliding():
		velocity += get_gravity() * delta
		
	
				
	input_dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	update_animation_parameters()
	anim_body.rotation.y = lerp_angle(anim_body.rotation.y, atan2(input_dir.x, input_dir.y), delta * ANGULAR_ACELERATION)
	move_and_slide()
