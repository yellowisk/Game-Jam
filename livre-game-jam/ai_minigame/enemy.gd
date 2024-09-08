extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

var SPEED = 3.0
var throw_mode = false

func _process(delta: float) -> void:
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED

	if (current_location.distance_squared_to(nav_agent.target_position)) < 1.5:
		get_parent().player_captured.emit()

	velocity = new_velocity
	move_and_slide()

func throw(boolean: bool):
	throw_mode = boolean

func update_target_location(target_location):
	nav_agent.target_position = target_location
	if self.global_position.distance_squared_to(target_location) < 1.5 && throw:
		queue_free()
