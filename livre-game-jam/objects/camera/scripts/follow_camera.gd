extends Node3D

@export var target: Node3D

var obj_list : Array
var target_pos
var list_len

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_list = get_parent().get_children().filter(func(x): return x is Node3D)
	if target == null:
		target = obj_list[0]
		target_pos = 0
		list_len = len(obj_list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("change"):
		obj_list = get_parent().get_children().filter(func(x): return x is Node3D)
		if target == null:
			target = obj_list[0]
			target_pos = 0
			list_len = len(obj_list)
		target_pos += 1
		if target_pos == list_len:
			target_pos = 0
		target = obj_list[target_pos]
		 
	global_position = target.global_position
