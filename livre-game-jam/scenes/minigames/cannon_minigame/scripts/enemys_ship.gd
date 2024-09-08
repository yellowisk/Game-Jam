extends RigidBody3D

const TARGET_NUM = 4;

@onready var TARGET_SCENE = preload("res://scenes/minigames/cannon_minigame/target.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func start_minigame() -> void:
	var target_parents = Node3D.new()
	get_parent().add_child.call_deferred(target_parents)
	spawn_target(target_parents)

func spawn_target(target_parents):
	var _z = -27
	var counter = 0
	while counter < TARGET_NUM:
		var random_x = randi_range(-3, 18)
		var random_y = randi_range(-1, 3)
	
		var target = TARGET_SCENE.instantiate()
		target_parents.add_child(target)
		target.transform.origin = Vector3(random_x, random_y, _z)
		counter += 1
		await get_tree().create_timer(3).timeout
