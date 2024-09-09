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
	var ip = "127.0.0.1" if $Hud/TextEdit.text == "" else $Hud/TextEdit.text
	peer.create_client(ip,1027)
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


func _on_ocean_bottom_body_entered(body):
	if body.is_in_group("players"):
		body.position = Vector3(0, 5, 0)
