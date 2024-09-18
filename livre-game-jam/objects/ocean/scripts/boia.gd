extends RigidBody3D

@onready var water = $"../Ocean"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.global_position.y = water.get_height(self.global_position)
