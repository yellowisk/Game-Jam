extends CanvasLayer

func _on_host_pressed() -> void:
	get_parent().host()
	visible = false
	
func _on_join_pressed() -> void:
	get_parent().join()
	visible = false
