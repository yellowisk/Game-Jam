extends CharacterBody3D

const SPEED = 5.

@onready var cam = $SpringArm3D/Camera3D

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
			
		if Input.is_action_just_pressed("quit"):
			$"../".exit_game(name.to_int()) 
			get_tree().quit()

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			#velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			#velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()
