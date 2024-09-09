extends CharacterBody3D

const SPEED = 5.0

var player_controlling = false;
var points = 0;

func _physics_process(delta: float) -> void:
	if not player_controlling:
		return;
		
	if not is_on_floor() and position.y > -4.5:
		velocity += get_gravity() * delta 
	if position.y < -4.5:
		velocity -= get_gravity() * delta 

	if Input.is_action_just_pressed("quit"):
		$"/root/Main".exit_game(name.to_int()) 
		get_tree().quit()
	
	var input_dir := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	var direction := (transform.basis * Vector3(0, 0, input_dir)).normalized()
	if direction:
		velocity.z = direction.z * SPEED
	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Fruta"):
		body.queue_free()
		points += 1
		if points >= 7:
			$"../..".finished_barrel.emit()
