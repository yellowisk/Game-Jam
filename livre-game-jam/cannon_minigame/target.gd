extends StaticBody3D

func _cannon_hit(body: Node3D) -> void:
	if body.is_in_group("projeteis"):
		Global.cannon_minigame_points += 1
		print(Global.cannon_minigame_points)
		await get_tree().create_timer(0.05).timeout
		body.queue_free()
		queue_free()
