extends Node3D

@rpc("any_peer", "call_local")
func update_path(progress: float):
	%ShipPathFollow.progress += progress
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.level_area_enter.connect(set_level)
	Signals.level_area_exit.connect(unset_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	var progress = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if progress != 0.0:
		update_path.rpc_id(1, progress)

func set_level(level_name: String):
	%PlayLevelButton.text = level_name
	%PlayLevelButton.visible = true

func unset_level():
	%PlayLevelButton.text = "level_0"
	%PlayLevelButton.visible = false
	
func _on_play_level_button_pressed() -> void:
	start_level.rpc(%PlayLevelButton.text)

@rpc("any_peer", "call_local")
func start_level(level_name: String):
	print("Starting level: " + level_name)
	var next_scene = "res://scenes/levels/scenes/{0}.tscn".format([level_name])
	SceneTransition.change_scene(load(next_scene))
