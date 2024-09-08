extends CanvasLayer

func _on_host_pressed() -> void:
	get_parent()._on_host_pressed()
	
func _on_join_pressed() -> void:
	get_parent()._on_join_pressed()
