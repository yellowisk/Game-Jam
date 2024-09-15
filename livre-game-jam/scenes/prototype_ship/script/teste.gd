extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	peer.connect("peer_disconnected", del_player)
	multiplayer.connect("server_disconnected", server_closed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("quit"):
			multiplayer.multiplayer_peer.close()
			$Hud.visible = true
			
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
	
func del_player(id):
	get_node(str(id)).queue_free()
	
func server_closed():
	$Hud.visible = true;

func _on_ocean_bottom_body_entered(body):
	if body.is_in_group("players"):
		body.position = Vector3(0, 5, 0)
