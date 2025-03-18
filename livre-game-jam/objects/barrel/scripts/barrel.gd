extends "res://objects/ships/scripts/ship.gd"

var points = 0;

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Fruta"):
		body.queue_free()
		points += 1
