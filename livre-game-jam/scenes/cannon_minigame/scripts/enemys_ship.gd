extends StaticBody3D

var scene_to_instance = preload("res://scenes/cannon_minigame/target.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var target_parents = Node3D.new()
	get_parent().add_child.call_deferred(target_parents)
	await spawn_target(target_parents)

func spawn_target(target_parents):
	var _z = 1
	var counter = 0
	while counter < 10:
		var random_x = randi_range(-23, 23)
		var random_y = randi_range(4, 12)
	
		var target = scene_to_instance.instantiate()
		target.global_transform.origin = Vector3(random_x, random_y, _z)
		target_parents.add_child(target)
		counter += 1
		await get_tree().create_timer(1).timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
