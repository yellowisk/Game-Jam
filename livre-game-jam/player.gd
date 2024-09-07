extends CharacterBody3D


const SPEED = 10.0
const ANGULAR_ACELERATION = 7
const JUMP_VELOCITY = 7
@onready var cam = $SpringArm3D/Camera3D

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready():
	cam.current = is_multiplayer_authority()

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * 2 * delta

		if Input.is_action_just_pressed("quit"):
			$"../".exit_game(name.to_int()) 
			get_tree().quit()
			
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
								Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		$Body.rotation.y = lerp_angle($Body.rotation.y, atan2(direction.x, direction.z), delta * ANGULAR_ACELERATION)
		
		move_and_slide()
