extends CharacterBody3D

@export var speed = 4.0
@export var input: PlayerInput
@onready var rollback_synchronizer = $RollbackSynchronizer
@export var camera : Camera3D

var peer_id = 0
func _enter_tree() -> void:
	await get_tree().process_frame
	print("player_enter_tree ", name)
	peer_id = name.to_int()
	set_multiplayer_authority(peer_id)
	input.set_multiplayer_authority(peer_id)
	rollback_synchronizer.process_settings()
	camera.current = is_multiplayer_authority()
	
func _ready():
	position.y = 5

func _rollback_tick(delta, tick, is_fresh):

	velocity = input.movement.normalized() * speed
	# Add the gravity.
	_force_update_is_on_floor()
	if not is_on_floor():
		velocity += get_gravity() * delta
	velocity *= NetworkTime.physics_factor
	move_and_slide()
	velocity /= NetworkTime.physics_factor
func _force_update_is_on_floor():
	var old_velocity = velocity
	velocity = Vector3.ZERO
	move_and_slide()
	velocity = old_velocity
