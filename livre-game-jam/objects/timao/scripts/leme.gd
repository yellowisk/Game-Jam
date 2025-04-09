extends Controllable

const MAX_ROTATION = 360.0

@export var sens := 1.0
@onready var rot = rotation_degrees

func _process(_delta: float):
	if player_controlling != multiplayer.get_unique_id():
		return;
	
	if Input.is_action_pressed("move_right"):
		rot = clamp(rotation_degrees.x - sens, -MAX_ROTATION, MAX_ROTATION)

	if Input.is_action_pressed("move_left"):
		rot = clamp(rotation_degrees.x + sens, -MAX_ROTATION, MAX_ROTATION)

@rpc("any_peer", "call_remote")
func rotate_leme(rot):
	rotation_degrees.x = rot
	
