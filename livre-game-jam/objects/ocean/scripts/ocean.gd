extends Node3D


@onready var center_ocean : MeshInstance3D = $"CenterOcean"

var center_material: ShaderMaterial
var noise: Image
var noise_scale = 1 #Size of mesh / size of noise_texture
@export var time : float = 0

@export var wave_speed = Vector2(0.1, 0.1)
@export var wave_height: float = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	center_material = center_ocean.mesh.surface_get_material(0)
	noise = center_material.get_shader_parameter("wave_bump").noise.get_seamless_image(512, 512)
	center_material.set_shader_parameter("wave_speed", wave_speed)
	center_material.set_shader_parameter("wave_height", wave_height)
	
func _process(delta):
	center_material.set_shader_parameter("time", time)
	time += delta
	
func get_height(world_position: Vector3) -> float:
	var uv_x = wrapf((world_position.x - 256) / noise_scale + time * wave_speed.x * noise.get_width(), 0, noise.get_width())
	var uv_y = wrapf((world_position.z - 256) / noise_scale + time * wave_speed.y * noise.get_height(), 0, noise.get_height())

	var pixel_pos = Vector2(uv_x, uv_y)
	#print(pixel_pos)
	return global_position.y + noise.get_pixelv(pixel_pos).r * wave_height;
