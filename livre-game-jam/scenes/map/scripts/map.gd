extends Node3D

@rpc("any_peer")
func update_path(progress: float):
	%ShipPathFollow.progress += progress
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	var progress = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if progress != 0.0:
		update_path.rpc_id(1, progress)
