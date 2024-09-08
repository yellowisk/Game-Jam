extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var score = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = "Pontuação: %d" % Lobby.global_points
