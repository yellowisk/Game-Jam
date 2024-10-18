extends CanvasLayer

@export var text_box: TextEdit

func _on_host_pressed():
	Signals.emit_signal("host_server")
	visible = false

func _on_join_pressed():
	Signals.emit_signal("join_server", text_box.text)
	visible = false
