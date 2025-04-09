extends Ship

const TARGET_NUM = 8;
@onready var timer = $Timer
@onready var target_parents = $TargetParent

@onready var TARGET_SCENE = preload("res://objects/cannon/scenes/target.tscn")
@export var health := 5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if health <= 0:
		queue_free()
	
func start_minigame() -> int:
	add_child(target_parents)
	return await spawn_target(target_parents);

func spawn_target(target_parents) -> int:
	var _z = 0
	var counter = 0
	while counter < TARGET_NUM:
		var random_x = randi_range(-10, 10)
		var random_y = randi_range(-3, 5)
	
		var target = TARGET_SCENE.instantiate()
		target_parents.add_child(target)
		target.transform.origin = Vector3(random_x, random_y, _z)
		counter += 1
		timer.start(5)
		await timer.timeout
		
	timer.start(5)
	await timer.timeout
	target_parents.queue_free()
	
	return (get_child_count() - 1 );
	
	
