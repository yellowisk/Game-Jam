extends CharacterBody3D

@export var anim_body: Node3D
@export var anim_tree: AnimationTree
@export var camera: Camera3D
@export var direction := Vector3.ZERO
@export var jump := 0.0
@export var state := "idle"
@export var peer_position := Vector3.ZERO

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const  ANGULAR_ACELERATION = 7.0
const PEER_CORRECTION = 0.1

func _enter_tree() -> void:
	print("player_enter_tree ", name)
	set_multiplayer_authority(name.to_int())
	
func _ready():
	camera.current = is_multiplayer_authority()
	print("player_name ", name)
	print(camera.current)
	position.y = 5
	peer_position = position
	self.add_to_group("players")
	anim_tree.active = true

func update_animation_parameters():
	if is_multiplayer_authority():
		if velocity.y > 0:
			state = "jumping"
		elif not is_on_floor():
			state = "on_air"
		elif direction != Vector3.ZERO:
			state = "moving"
		else:
			state = "idle"
	
	match state:
		"idle":
			anim_tree["parameters/conditions/idle"] = true
			anim_tree["parameters/conditions/is_moving"] = false
			anim_tree["parameters/conditions/is_on_air"] = false
			anim_tree["parameters/conditions/jump"] = false
		"moving":
			anim_tree["parameters/conditions/idle"] = false
			anim_tree["parameters/conditions/is_moving"] = true
			anim_tree["parameters/conditions/is_on_air"] = false
			anim_tree["parameters/conditions/jump"] = false
		"on_air":
			anim_tree["parameters/conditions/idle"] = false
			anim_tree["parameters/conditions/is_moving"] = false
			anim_tree["parameters/conditions/is_on_air"] = true
			anim_tree["parameters/conditions/jump"] = false
		"jumping":
			anim_tree["parameters/conditions/idle"] = false
			anim_tree["parameters/conditions/is_moving"] = false
			anim_tree["parameters/conditions/is_on_air"] = false
			anim_tree["parameters/conditions/jump"] = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_multiplayer_authority():
		var input_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		jump = Input.get_action_strength("jump") if is_on_floor() and Input.is_action_just_pressed("jump") else 0
		peer_position = position
	else:
		position.x = move_toward(position.x, peer_position.x, PEER_CORRECTION)
		#position.y = move_toward(position.y, peer_position.y, PEER_CORRECTION)
		position.z = move_toward(position.z, peer_position.z, PEER_CORRECTION)
		
	# Handle jump.
	if jump != 0:
		velocity.y = JUMP_VELOCITY * jump
		
	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	anim_body.rotation.y = lerp_angle(anim_body.rotation.y, atan2(direction.x, direction.z), delta * ANGULAR_ACELERATION)
	update_animation_parameters()
	move_and_slide()
