extends Node

@export var global_points = 0;

@export var CURRENT_EVENT = null;

@onready var ENEMY_SHIP = $"/root/Main/MinigameController/EnemysShip";

@onready var MinigameEvent =  {
	CANNON_WAR = {
		start = Callable(self, "start_war"),
		end = Callable(self, "end_war"),
		cam = $"Cannons/Camera3D",
	},
}
	
@rpc("any_peer", "call_local", "reliable")
func score(p: int):
	global_points += p;
	
@rpc("authority", "call_local", "reliable")
func set_event(event):
	CURRENT_EVENT = event
	
	if CURRENT_EVENT == "CANNON_WAR":
		ENEMY_SHIP.visible = true;
		pass
		
@rpc("any_peer", "call_local", "reliable")
func end_event(event):
	CURRENT_EVENT = null
	
	if event == "CANNON_WAR":
		ENEMY_SHIP.visible = false;
