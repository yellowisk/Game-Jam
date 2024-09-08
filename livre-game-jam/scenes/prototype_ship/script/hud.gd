extends CanvasLayer

func _on_host_pressed() -> void:
	get_parent().host()
	hide()

func _on_join_pressed() -> void:
	get_parent().join($TextEdit.text)
	hide()
