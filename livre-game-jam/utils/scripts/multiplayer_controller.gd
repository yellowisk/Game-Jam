extends Node

@export var address = "127.0.0.1"
var multiplayer_peer

func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

func peer_connected(id):
	print("Player Connected " + str(id))
	Signals.join_server.emit(id)

func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	Signals.player_disconnect.emit()

func connected_to_server():
	print("Conected to Server!")
	send_player_information.rpc_id(1, "player", multiplayer.get_unique_id())
	
func connection_failed():
	print("Couldnt Connect")

@rpc("any_peer", "call_local")
func start_game():
	SceneTransition.change_scene(preload("res://scenes/map/scenes/Map.tscn"))
	Signals.start_game.emit()

	
func host(port, max_players) -> void:
	multiplayer_peer = ENetMultiplayerPeer.new()
	var error = multiplayer_peer.create_server(port, max_players)
	if error != OK:
		print("cannot host: " + str(error))
		return
		
	multiplayer_peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(multiplayer_peer)
	print("Waiting for Players!")
	GameManager.max_players = max_players
	Signals.host_server.emit()

func join(port) -> void:
	multiplayer_peer = ENetMultiplayerPeer.new()
	multiplayer_peer.create_client(address, port)
	multiplayer_peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(multiplayer_peer)

func start() -> void:
	start_game.rpc()
	Signals.start_game.emit()
	pass # Replace with function body.
	
func add_player_character(peer_id):
	var player_character = preload("res://objects/player/scenes/rb_player.tscn").instantiate()
	player_character.set_multiplayer_authority(peer_id)
	add_child(player_character)
	
@rpc("any_peer")
func send_player_information(name, id):
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name":name,
			"id": id,
			"score": 0
		}

	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i].name, i)
	
	Signals.update_player_count.emit(str(len(GameManager.players)) + "/" + str(GameManager.max_players))
