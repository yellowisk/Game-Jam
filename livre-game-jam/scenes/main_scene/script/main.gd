extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.start_game.connect(start_game)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	SceneTransition.change_scene(preload("res://scenes/map/scenes/map.tscn"))
