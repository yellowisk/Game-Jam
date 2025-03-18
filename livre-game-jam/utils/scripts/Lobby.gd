extends Node

@export var global_points = 0;

@export var CURRENT_EVENT = null;

@onready var ENEMY_SHIP = $"/root/Main/MinigameController/EnemysShip";
@onready var SHIP = $"/root/Main/Ship";
@onready var START_CANNON = $"/root/Main/MinigameController/Cannons/CannonStart";
@onready var START_BARREL = $"/root/Main/MinigameController/BarrilGame/BarrelStart";
@onready var START_TIMAO = $"/root/Main/Ship/TimaoStart";

	
@rpc("any_peer", "call_local", "reliable")
func score(p: int):
	global_points += p;
	
@rpc("authority", "call_local", "reliable")
func set_event(event):
	CURRENT_EVENT = event
	
	if CURRENT_EVENT == "CANNON_WAR":
		START_CANNON.visible = true;
		ENEMY_SHIP.visible = true;
	elif CURRENT_EVENT == "BARREL":
		START_BARREL.visible = true;
	elif CURRENT_EVENT == "TIMAO":
		var tilt_speed = randfn(0, 0.6);
		while tilt_speed == 0:
			tilt_speed = randfn(0, 0.6);
			 
		tilt_speed = clamp(tilt_speed, -0.5, 0.5);
		SHIP.angular_velocity = Vector3(tilt_speed, 0, 0);
		SHIP.reset_ship_after_delay.call_deferred();
		
@rpc("any_peer", "call_local", "reliable")
func end_event(event):
	CURRENT_EVENT = null
	
	if event == "CANNON_WAR":
		START_CANNON.visible = false;
		ENEMY_SHIP.visible = false;
	elif event == "BARREL":
		START_BARREL.visible = false;
	elif event == "TIMAO":
		START_TIMAO.visible = false;
