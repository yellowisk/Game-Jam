extends CanvasLayer
	
func _ready() -> void: 
	Signals.hide_menu.connect(_hide)
	Signals.update_player_count.connect(_update_players)

func _on_host_pressed() -> void:
	MultiplayerController.host(
		%PortInputHost.text.to_int(), 
		%MaxPlayersInput.text.to_int()
	)
	%PlayerJoinedHost.text = str(len(GameManager.players)) + "/" + str(GameManager.max_players)
	%PlayerJoinedPlay.text = str(len(GameManager.players)) + "/" + str(GameManager.max_players)

func _on_join_pressed() -> void:
	MultiplayerController.join(%PortInputJoin.text.to_int())

func _on_start_pressed() -> void:
	MultiplayerController.start()
	
func _hide():
	self.hide()
	
func _update_players(player_count:String) -> void:
	%PlayerJoinedHost.text = player_count
	%PlayerJoinedPlay.text = player_count
