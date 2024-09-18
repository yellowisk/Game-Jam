extends Camera3D

# How fast the camera speeds up to the moveSpeed and slows down to zero.
@export var acceleration = 50.0

# The top speed of the camera.
@export var moveSpeed = 8.0

# The speed of the mouse input.
@export var mouseSpeed = 300.0

# The speed and dead-zone of the controllers input.
@export var controllerSpeed = 4.5
@export var controllerDeadZone = 0.04

# The current velocity of the camera.
var velocity = Vector3.ZERO

# The look angles and controller Look Input.
var lookAngles = Vector2.ZERO
var controllerLook = Vector2.ZERO

func _process(delta):  
	# Rotate the camera with the controller.
	if controllerLook.length_squared() > controllerDeadZone:
		lookAngles -= controllerLook * delta * controllerSpeed


	# Limit how much we can look up and down.
	lookAngles.y = clamp(lookAngles.y, PI / -2, PI / 2)
	set_rotation(Vector3(lookAngles.y, lookAngles.x, 0))

	# Get the direction to move from the inputs.
	var dir = updateDirection()


	# Accelerate or decelerate depending on if we have a direction or not.
	if dir.length_squared() > 0:
		velocity += dir * acceleration * delta
	else:
		velocity += velocity.direction_to(Vector3.ZERO) * acceleration * delta

	# Kill the velocity if we are close to zero.
	if velocity.length() < 0.0005:
		velocity = Vector3.ZERO


	# Limit the camera's top speed to the moveSpeed then move the camera.
	if velocity.length() > moveSpeed:
		velocity = velocity.normalized() * moveSpeed
		translate(velocity * delta)

	# Give the player's mouse back when ESC is pressed.
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func updateDirection():
	# Get the direction to move the camera from the input.
	var dir = Vector3()
	if Input.is_action_pressed("move_up"):
		dir += Vector3.FORWARD
	if Input.is_action_pressed("move_down"):
		dir += Vector3.BACK
	if Input.is_action_pressed("move_left"):
		dir += Vector3.LEFT
	if Input.is_action_pressed("move_right"):
		dir += Vector3.RIGHT

	return dir.normalized()



func _input(event):

	# Update the look angles when the mouse moves.
	if event is InputEventMouseMotion:
		lookAngles -= event.relative / mouseSpeed


	# Steal the mouse from the player when they interact with the window using a
	# mouse button.      
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
