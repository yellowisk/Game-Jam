extends RigidBody3D

var scene_to_instance = preload("res://scenes/cannon_minigame/target.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var target_parents = Node3D.new()
	get_parent().add_child.call_deferred(target_parents)
	await spawn_target(target_parents)

func spawn_target(target_parents):
	var _z = 14
	var counter = 0
	while counter < 10:
		var random_x = randi_range(-8, 13)
		var random_y = randi_range(5, 7)
	
		var target = scene_to_instance.instantiate()
		target.transform.origin = Vector3(random_x, random_y, _z)
		target_parents.add_child(target)
		counter += 1
		await get_tree().create_timer(3).timeout
