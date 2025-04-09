extends HBoxContainer

@export var player: RigidBody3D

@onready var acceleration = $Acceleration
@onready var friction = $Friction
@onready var speed = $Speed
@onready var is_on_floor = $IsOnFloor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#acceleration.text = "Acceleration: " + str(player.accel_multiplier).pad_decimals(2)
	friction.text = "Friction: " + str(player.physics_material_override.friction).pad_decimals(2)
	speed.text = "Speed: " + str(player.current_speed).pad_decimals(2)
	is_on_floor.text = "Is on floor: " +  str(player.is_on_floor)
