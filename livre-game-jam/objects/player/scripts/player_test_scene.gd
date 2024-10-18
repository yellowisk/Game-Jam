extends Node3D

@export var player_scene : PackedScene

var peer = ENetMultiplayerPeer.new()

signal host_button_pressed
signal join_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("host_button_pressed", host)
	connect("join_button_pressed", join)

	peer.connect("peer_disconnected", del_player)
	multiplayer.connect("server_disconnected", server_closed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("quit"):
			multiplayer.multiplayer_peer.close()
			
func host() -> void:
	print("starting host")
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()

func join(ip:String = "127.0.0.1") -> void:
	peer.create_client(ip,1027)
	multiplayer.multiplayer_peer = peer

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	
func del_player(id):
	get_node(str(id)).queue_free()
	
func server_closed():
	pass
	
func _on_ocean_bottom_body_entered(body):
	if body.is_in_group("players"):
		body.position = Vector3(0, 5, 0)
