extends Minigame

func _ready() -> void:
	Signals.end_minigame.connect(_end_game)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name: 
		"enemy_ship": $EnemysShip.start_minigame()
		"enemy_ship_end": $EnemysShip.queue_free()

func _end_game(id):
	print(self.id, id)
	if self.id == id: 
		$AnimationPlayer.play("enemy_ship_end")
