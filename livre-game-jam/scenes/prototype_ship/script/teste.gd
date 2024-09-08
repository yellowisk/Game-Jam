extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

signal stop_player_flag

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_pressed() -> void:
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	$Hud.hide()

func _on_join_pressed() -> void:
	peer.create_client("127.0.0.1" if $CanvasLayer/TextEdit.text == "" else $CanvasLayer/TextEdit.text,1027)
	multiplayer.multiplayer_peer = peer
	$Hud.hide()

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	player.add_to_group("players")
	
func exit_game(id):	
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)
	
func del_player(id):
	rpc("del_player", id)
	
@rpc("any_peer", "call_local")
func _del_player(id):
	get_node(str(id)).queue_free()

func _on_stop_player_flag(id) -> void:
	#get all children that are from the group players
	var player = null
	for child in get_children():
		if child.is_in_group("players") && child.name == id:
			player = child
			break
	
	player.is_on_wheel = true
