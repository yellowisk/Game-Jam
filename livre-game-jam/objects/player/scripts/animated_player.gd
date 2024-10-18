extends RigidBody3D

@export var rigid_body : RigidBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = rigid_body.global_position 
