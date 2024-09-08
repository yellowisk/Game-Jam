extends CharacterBody3D

const SPEED = 5.0

var scene_to_instance = preload("res://minigame_barrel/fruta.tscn")

func _ready():
	var fruits_parent = Node3D.new()
	get_parent().add_child.call_deferred(fruits_parent)

	var positions = [Vector3(-5, 6, 0), Vector3(-4, 6, 0),  Vector3(-3, 6, 0),  Vector3(-2, 6, 0), 
	Vector3(-1, 6, 0),  Vector3(0, 6, 0),  Vector3(1, 6, 0),  Vector3(2, 6, 0), Vector3(3, 6, 0),
	 Vector3(4, 6, 0),  Vector3(-4, 6, 0)]
	
	await spawn_fruits(fruits_parent, positions)

func spawn_fruits(fruits_parent, positions) -> void:
	var counter = 0
	while counter < 20:
		var random_int = randi_range(0, 10)
		var pos = positions[random_int]
		var fruit = scene_to_instance.instantiate()
		fruit.global_transform.origin = pos
		fruits_parent.add_child(fruit)

		counter += 1
		
		await get_tree().create_timer(1.5).timeout
	print(Global.points_barrel_minigame)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta 

	if Input.is_action_just_pressed("quit"):
		$"../".exit_game(name.to_int()) 
		get_tree().quit()
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Fruta":
		await get_tree().create_timer(0.05).timeout
		body.queue_free()
		Global.points_barrel_minigame += 1
