extends StaticBody3D

func _cannon_hit(body: Node3D) -> void:
	if body.is_in_group("projeteis"):
		Global.cannon_minigame_points += 1
		await get_tree().create_timer(0.05).timeout	
		if is_instance_valid(body): # Checa se o body já não foi freed
			body.free()
		if is_instance_valid(self): # Checa se o body já não foi freed
			self.free()
