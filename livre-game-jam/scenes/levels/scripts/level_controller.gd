extends Node

@onready var player_scene := preload("res://objects/player/scenes/rb_player.tscn")
@onready var camera_scene := preload("res://objects/camera/scenes/follow_camera.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index = 0
	for player in GameManager.players.values():
		print("Summoning player: " + str(player['name']))
		var current_player = player_scene.instantiate()
		current_player.name = str(player['id'])
		add_child(current_player)
		var player_camera = camera_scene.instantiate()
		player_camera.target = current_player
		add_child(player_camera)
		for spawn in get_tree().get_nodes_in_group("player_spawn_point"):
			if spawn.name == str(index):
				current_player.global_position = spawn.global_position
				print("Player in position: " + str(index))
		index += 1
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
