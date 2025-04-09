extends Node3D

@onready var camera_scene := preload("res://objects/camera/scenes/follow_camera.tscn")
@onready var enemy_ship = $EnemysShip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_ship.start_minigame()
	$Player.set_multiplayer_authority(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
