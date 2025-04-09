extends Node3D

@onready var spring_arm = $SpringArm3D

@export var target: Node3D
@export var distance_view:= 5.0
@export var controllerDeadZone = 0.04
@export var controllerSpeed = 4.5
@export var mouseSpeed = 300.0

var obj_list : Array
var target_pos = 0
var list_len = 0
var lookAngles = Vector2.ZERO
var controllerLook = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	obj_list = get_tree().get_nodes_in_group("players")
	if target == null:
		if len(obj_list) == 0:
			target = get_parent_node_3d()
		else:
			target = obj_list[0]
			target_pos = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotate the camera with the controller.
	#if controllerLook.length_squared() > controllerDeadZone:
		#lookAngles -= controllerLook * delta * controllerSpeed


	# Limit how much we can look up and down.
	#lookAngles.y = clamp(lookAngles.y, PI / -2, PI / 2)
	#set_rotation(Vector3(lookAngles.y, lookAngles.x, 0))

	if target:
		if Input.is_action_just_pressed("change"):
			obj_list = get_tree().get_nodes_in_group("players")
			target_pos += 1
			if target_pos >= len(obj_list):
				target_pos = 0
			if len(obj_list) > 0:
				target = obj_list[target_pos] 
		global_position = target.global_position
	else:
		obj_list = get_tree().get_nodes_in_group("players")
		if len(obj_list) > 0:
			target = obj_list[0]
			target_pos = 0
	spring_arm.spring_length = lerp(spring_arm.spring_length, distance_view, 0.2) 
	
func _input(event):
	# Update the look angles when the mouse moves.
	#if event is InputEventMouseMotion:
		#lookAngles -= event.relative / mouseSpeed


	# Steal the mouse from the player when they interact with the window using a
	# mouse button.      

	if event is InputEventMouseButton:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				distance_view -= 0.5
				# call the zoom function
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				distance_view += 0.5
