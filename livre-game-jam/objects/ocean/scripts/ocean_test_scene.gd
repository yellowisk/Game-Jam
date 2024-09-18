extends Node3D

@export var boia_scene: PackedScene
@onready var ocean = $Ocean
# Called when the node enters the scene tree for the first time.

func spawn_boias():
	for i in range(-256, 1+256, 16):
		for j in range(-256, 1+256, 16):
			spawn_boia(i, j)
func spawn_boia(x, z):
	var boia = boia_scene.instantiate()
	boia.position = Vector3(x, 8, z)
	call_deferred("add_child", boia)
	
func _ready():
	spawn_boias()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
