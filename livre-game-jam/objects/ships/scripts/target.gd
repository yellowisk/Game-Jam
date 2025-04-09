extends Area3D

@onready var timer = $Timer
@onready var target = $Target
@onready var body = $CollisionShape3D

func _cannon_hit(body: Node3D) -> void:
	if body.is_in_group("projeteis"):
		get_parent().get_parent().health -= 1
		await get_tree().create_timer(0.05).timeout	
		if is_instance_valid(body): # Checa se o body já não foi freed
			body.free()
		if is_instance_valid(self): # Checa se o body já não foi freed
			self.free()

func _ready() -> void:
	timer.start(5)
	
func _process(delta: float) -> void:
	target.scale = Vector3(timer.time_left / 5, timer.time_left / 5, timer.time_left / 5) 
	body.shape.radius = 3 * timer.time_left / 5
func _on_timer_timeout() -> void:
	queue_free()
