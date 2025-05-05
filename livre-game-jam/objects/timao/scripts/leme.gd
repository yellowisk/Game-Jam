extends Controllable

const MAX_ROTATION = 360.0

@export var sens := 5.0
@onready var rot = 0
var ship: RigidBody3D

func _ready() -> void:
	ship = get_tree().get_first_node_in_group("ships")


func _process(_delta: float):
	#print(player_controlling, " ", multiplayer.get_unique_id())
	if player_controlling != multiplayer.get_unique_id():
		return;
	
	if Input.is_action_pressed("move_right"):
		rot = clamp(rot - sens, -MAX_ROTATION, MAX_ROTATION)

	if Input.is_action_pressed("move_left"):
		rot = clamp(rot + sens, -MAX_ROTATION, MAX_ROTATION)

	rotate_leme.rpc_id(1, rot)
	
	
@rpc("any_peer", "call_local")
func rotate_leme(rot):
	$LemeMesh.rotation_degrees.x = rot
	ship.angular_velocity = Vector3.LEFT * deg_to_rad(rot)
	
