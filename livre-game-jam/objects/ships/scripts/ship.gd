extends RigidBody3D
class_name Ship

@export var float_force := 150.0
@export var water_drag := 0.1
@export var water_angular_drag := 0.5

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var probes = $ProbeContainer.get_children()

@export var reset_duration := 2.0
var resetting := false  # To track if the reset is in progress
var reset_timer := 0.0  # Timer to smoothly interpolate back

var submerged := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if resetting:
		# Gradually return to the original position
		reset_timer += delta / reset_duration
		global_rotation = global_rotation.slerp(Vector3(0, 0, 0), reset_timer)
		
		if reset_timer >= 1.0:
			resetting = false  # Stop resetting once done
			position = Vector3(0, 0, 0)
			linear_velocity = Vector3(0, 0, 0)
			angular_velocity = Vector3(0, 0, 0)
			rotation = Vector3(0, 0, 0)
			
	submerged = false
	for p in probes:
		var depth = Ocean.get_height(p.global_position) - p.global_position.y 
		if depth > 0:
			submerged = true
			apply_force(Vector3.UP * float_force * gravity * depth, p.global_position - global_position)

func _integrate_forces(state: PhysicsDirectBodyState3D):
	if submerged:
		state.linear_velocity *=  1 - water_drag
		state.angular_velocity *= 1 - water_angular_drag 
		
func reset_ship_after_delay() -> void:
	resetting = true
	reset_timer = 0.5
