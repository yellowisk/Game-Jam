extends RigidBody3D

func _ready() -> void:
	add_constant_central_force(Vector3.DOWN * 0.91)
	await get_tree().create_timer(3).timeout
	queue_free()
