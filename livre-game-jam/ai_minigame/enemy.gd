extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 3.0

func _process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED

	if (current_location.distance_squared_to(nav_agent.target_position)) < 1.5:
		get_parent().player_captured.emit()

	velocity = new_velocity
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location
