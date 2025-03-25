extends Control

var image = Image.new()
var total_duration = 0
func config_ticket(id: String, type:String, duration: int):
	match type:
		"timao": image.load("res://scenes/hud/resources/helm.png")
		"food": image.load("res://scenes/hud/resources/apple.png")
		"fight": image.load("res://scenes/hud/resources/pirate-ship.png")
		"barrel": image.load("res://scenes/hud/resources/barrel.png")
		"invasion": image.load("res://scenes/hud/resources/pirate.png")
		"kraken": image.load("res://scenes/hud/resources/kraken.png")
	%Icon.texture = ImageTexture.new().create_from_image(image)
	%EventName.text = type
	total_duration = duration
	$Timer.start(duration)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	config_ticket("111", "timao", randi_range(10, 60))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%ProgressBar.value = $Timer.time_left / total_duration
	var new_color = Color(
		1 - $Timer.time_left / total_duration, 
		$Timer.time_left / total_duration, 
		0)
	%ProgressBar.get("theme_override_styles/fill").bg_color = new_color


func _on_timer_timeout() -> void:
	queue_free()
