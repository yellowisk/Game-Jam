extends Node3D

@export var target: Node3D
@export var distance_view:= 30.0

var obj_list : Array
var target_pos = 0
var list_len = 0

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
			
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			# zoom in
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				distance_view -= 0.5
				# call the zoom function
			# zoom out
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				distance_view += 0.5
			$SpringArm3D.spring_length = distance_view
