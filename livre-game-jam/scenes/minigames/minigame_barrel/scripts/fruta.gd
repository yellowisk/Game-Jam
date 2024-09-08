extends RigidBody3D

@export var apple_scene : PackedScene
@export var banana_scene : PackedScene
@export var bread_scene : PackedScene

# Called when the node enters the scene tree for the first time
func _ready():
	var variant_list = [apple_scene, banana_scene, bread_scene]
	var obj = variant_list[randi_range(0, 2)].instantiate()
	add_child(obj)
