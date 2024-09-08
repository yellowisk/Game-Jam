extends CharacterBody3D


const SPEED = 10.0
const ANGULAR_ACELERATION = 7
const JUMP_VELOCITY = 7

@onready var cam = $SpringArm3D/Camera3D
@onready var animation = $Body/PlayerRig/AnimationPlayer
@onready var area_colision = $Body/Area3D/CollisionShape3D
@onready var area = $Body/Area3D
@onready var action;

@export var current_animation = "idle"

var is_capt = false
var is_hold = false
var holder:CharacterBody3D = null

func captured(body: CharacterBody3D):
	area_colision.disabled = true
	is_capt = true
	holder = body
	
func throw():
	holder.linear_velocity = global_basis.x.rotated(global_basis.z, PI/4) * 22
	holder.is_capt = false
	holder = null
	is_hold = false
	
	

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
func _ready():
	cam.current = is_multiplayer_authority()
	position.y = 5
	self.add_to_group("players")

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		
		if Input.is_action_just_released("quit"):
			$"../".exit_game(name.to_int()) 
			get_tree().quit()
			
		if is_capt:
			position = holder.position + Vector3(0, 2, 0)
			rotation = holder.rotation
			current_animation = "jump"
		else:
			# Add the gravity.
			if not is_on_floor():
				velocity += get_gravity() * 2 * delta
				
			if $Body/RayCastBottom.is_colliding() and not $Body/RayCastMid.is_colliding():
				velocity.y = JUMP_VELOCITY * 2.0/3

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var input_dir := Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
									Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
			var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				current_animation = "run"
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
				current_animation = "idle"
			$Body.rotation.y = lerp_angle($Body.rotation.y, atan2(direction.x, direction.z), delta * ANGULAR_ACELERATION)
			
		if Input.is_action_just_pressed("shoot"):
			if action != null:
				action.call(self)
			elif is_hold:
				throw()
			if is_on_floor():
					velocity.y = JUMP_VELOCITY
					current_animation = "jump"
			elif area.has_overlapping_bodies():
				var body = area.get_overlapping_bodies()[0]
				if body.is_in_group("players") and body.name != self.name:
					area_colision.disabled = true
					body.captured(self)
					is_hold = true
					
		move_and_slide()
	animation.current_animation = current_animation

func _on_area_3d_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
