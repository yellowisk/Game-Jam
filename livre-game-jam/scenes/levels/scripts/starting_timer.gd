extends Timer

var event

func config(event):
	self.event = event
	start(event["start"])

func _on_timeout() -> void:
	Signals.start_minigame.emit(event)
	queue_free()
