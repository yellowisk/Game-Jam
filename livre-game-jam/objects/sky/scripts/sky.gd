@tool

extends WorldEnvironment

@export_category("GodotSky Control")
@export_range(0, 2400, 0.01) var time_of_day : float = 1200.0
@export var simulate_time : bool = false
@export_range(0,10,0.01) var rate_of_time : float = 0.1
@export_range(0,360,0.1) var sky_rotation : float = 0.0
#@export var sky_preset : SkyPreset = preload()
@export var sun_color_light_gradient : Gradient

@onready var sun_moon_parent = $SunMoon
@onready var sun_root : MeshInstance3D = $SunMoon/Sun
@onready var moon_root : MeshInstance3D = $SunMoon/Moon
@onready var sun : DirectionalLight3D = $SunMoon/Sun/SunLight
@onready var moon : DirectionalLight3D = $SunMoon/Moon/MoonLight
@onready var sky : WorldEnvironment = $"."

var sun_position : float = 0.0
var moon_position : float = 0.0
var sun_pos_alpha : float = 0.0

func simulateDay():
	if (simulate_time == true):
		time_of_day += rate_of_time
		if (time_of_day >= 2400.0):
			time_of_day = 0.0
		
func updateLights():
	var sun_position = sun_root.global_position.y + 0.5
	moon_position = moon_root.global_position.y + 0.5
	sun.light_color = sun_color_light_gradient.sample(sun_position)

func updateRotation():
	var hour_mapped = remap(time_of_day, 0.0, 2400.0, 0.0, 1.0)
	sun_moon_parent.rotation_degrees.y = sky_rotation
	sun_moon_parent.rotation_degrees.x = hour_mapped * 360.0
	
func updateSky():
	sun_position = sun_root.global_position.y / 2.0 + 0.5
	
	var sky_material = self.environment.sky.get_material()
	updateLights()
	updateRotation()
	simulateDay()
	
func _process(delta):
	updateSky()
	
