extends Node3D


@export var fruit_scene : PackedScene

func spawn_fruits() -> void:
	var random_int = randi_range(-5, 5)
	var pos = Vector3(0, 0, random_int)
	var fruit = fruit_scene.instantiate()
	fruit.transform.origin = pos
	fruit.rotate(basis.y, PI/2)
	$FruitParents.add_child(fruit)
	$Timer.start(1.5)

func _on_timer_timeout() -> void:
	spawn_fruits()
