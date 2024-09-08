extends RigidBody3D

# Called when the node enters the scene tree for the first time
func _ready():
	await get_tree().create_timer(1.6).timeout
	queue_free()
