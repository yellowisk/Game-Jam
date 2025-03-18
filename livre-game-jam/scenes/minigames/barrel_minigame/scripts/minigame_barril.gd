extends Node3D


@export var apple_scene : PackedScene
@export var banana_scene : PackedScene
@export var bread_scene : PackedScene

var variant_list
# Called when the node enters the scene tree for the first time
func _ready():
	variant_list = [apple_scene, banana_scene, bread_scene]
	#$barrel.player_controlling = true


func spawn_fruits() -> void:
	var random_int = randf_range(-5, 5)
	var pos = Vector3(random_int, 0, 0)
	var fruit = variant_list[randi_range(0, 2)].instantiate()
	fruit.transform.origin = pos
	fruit.rotate(basis.y, PI/2)
	$FruitParents.add_child(fruit)
	$Timer.start(1.5)

func _on_timer_timeout() -> void:
	spawn_fruits()
