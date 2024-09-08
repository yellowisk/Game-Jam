extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

func host() -> void:
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()

func join(ip) -> void:
	peer.create_client("127.0.0.1" if ip == "" else ip,1027)
	multiplayer.multiplayer_peer = peer

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	player.position.x += id
	player.position.y = 10
	call_deferred("add_child", player)
	
func exit_game(id):	
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)
	
func del_player(id):
	rpc("del_player", id)
	
@rpc("any_peer", "call_local")
func _del_player(id):
	get_node(str(id)).queue_free()
