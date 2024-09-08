extends Node3D

var MinigameEvent =  {
	CANNON_WAR = {
		start = Callable(self, "start_war"),
		end = Callable(self, "end_war"),
	},
}

var CURRENT_EVENT = null;

signal start_event(event)

const MINIGAMES = {
	"invader": {
		"path": MINIGAMES_PATH[0],
	},
	"cannons": {
		"path": MINIGAMES_PATH[1],
	},
	"barrel": {
		"path": MINIGAMES_PATH[2],
	}
}

const MINIGAMES_PATH = ["res://scenes/minigames/ai_minigame/follow_path.tscn", "res://scenes/minigames/cannon_minigame/cannonball_minigame.tscn", "res://scenes/minigames/minigame_barrel/minigame_barril.tscn"]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cannon_start_body_entered(body):
	if body.is_in_group("players") and CURRENT_EVENT == MinigameEvent.INVASION:
		body.action = Callable(MinigameEvent.CANNON_WAR.start)
		
		
func start_invasion():
	pass
	
func end_invasion():
	pass
