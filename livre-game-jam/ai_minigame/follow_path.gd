extends Node

@onready var player = $Player
@onready var enemy = $Enemy

var capt = false

signal player_captured

func _process(delta: float) -> void:
	get_tree().call_group("enemies", "update_target_location", Vector3(0, 0, 0) if capt else player.global_transform.origin)
	get_tree().call_group("players", "enable_movement", false if capt else true)
	get_tree().call_group("players", "get_lerp", enemy.global_transform.origin)

func _on_player_captured() -> void:
	capt = true
