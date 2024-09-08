extends RigidBody3D

@export var float_force := 3.0
@export var water_drag := 0.05
@export var water_angular_drag := 0.05

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

const water_height := 0.0

var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var depth = water_height - global_position.y
	if depth > 0:
		apply_central_force(Vector3.UP * float_force * gravity * depth)
		
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if submerged:
		state.linear_velocity.y *= 1 - water_drag
		state.angular_velocity.y *= 1 - water_angular_drag
