extends StaticBody3D

func _cannon_hit(body: Node3D) -> void:
	if body.is_in_group("projeteis"):
		Global.cannon_minigame_points += 1
		await get_tree().create_timer(0.05).timeout	
		if body.is_queued_for_deletion():
			body.queue_free()
		self.queue_free()
