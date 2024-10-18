extends Node
class_name PlayerInput

var movement = Vector3.ZERO

func _ready():
	NetworkTime.before_tick_loop.connect(_gather)

func _gather():
	if not is_multiplayer_authority():
		return

	movement = Vector3(
		Input.get_axis("move_left", "move_right"),
		Input.get_action_strength("jump"),
		Input.get_axis("move_up", "move_down")
	)
