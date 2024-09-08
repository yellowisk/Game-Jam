extends RigidBody3D

@export var muzzle_velocity = 25
@export var g = Vector3.DOWN

func _ready() -> void:
	add_constant_central_force(Vector3.DOWN * 0.91)
