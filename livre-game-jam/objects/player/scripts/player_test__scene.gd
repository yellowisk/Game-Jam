extends Node3D

func _ready() -> void:
	$Player.set_multiplayer_authority(1)
