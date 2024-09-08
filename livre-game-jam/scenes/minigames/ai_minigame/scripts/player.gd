extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

signal aaa

var can_move = true
var lifter
var emitted = false
var plank

func lift(height, lifter):
	self.global_position = self.global_position.lerp(lifter.global_transform.origin + Vector3(0, 2, 0), 0.9)

func throw(lifter):
	plank = lifter

func enable_movement(boolean: bool) -> void:
	can_move = boolean

func get_lerp(obj) -> void:
	lifter = obj

func _process(delta: float) -> void:
	if can_move:
		plank = null
		lifter = null
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	elif (not emitted):
		#lift(2, lifter)
		emitted = true
		_on_player_aaa()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
func _on_player_aaa() -> void:
	lift(2, lifter)
	await get_tree().create_timer(10).timeout
	velocity = global_basis.x.rotated(global_basis.z, PI/4) * 10
	can_move = true
