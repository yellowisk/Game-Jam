extends Node3D

@export var points = 0;

@onready var ENEMY_SHIP = $"EnemysShip";

@onready var CANNON_PLAYER = load("res://scenes/minigames/cannon_minigame/scripts/cannon_player.gd")

@onready var MinigameEvent =  {
	CANNON_WAR = {
		start = Callable(self, "start_war"),
		end = Callable(self, "end_war"),
		cam = $"Cannons/Camera3D",
	},
}

var CURRENT_EVENT = null;

const MINIGAMES_PATH = ["res://scenes/minigames/ai_minigame/follow_path.tscn", "res://scenes/minigames/cannon_minigame/cannonball_minigame.tscn", "res://scenes/minigames/minigame_barrel/minigame_barril.tscn"]

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

# Called when the node enters the scene tree for the first time.
func _ready():
	CURRENT_EVENT = MinigameEvent.CANNON_WAR;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_cannon_start_body_entered(body):
	if body.is_in_group("players") and CURRENT_EVENT == MinigameEvent.CANNON_WAR:
		body.action = Callable(MinigameEvent.CANNON_WAR.start)
		
func _on_cannon_start_body_exited(body):
	body.action = null;
		
func start_war(player):
	ENEMY_SHIP.visible = true;
	player.visible = false;
	player.is_on_event = true;
	MinigameEvent.CANNON_WAR.cam.make_current();
	var canhao_player = $"../Ship/canhaoMinigame";
	canhao_player.player_controlling = true;
	
	var missing = await ENEMY_SHIP.start_minigame();
	
	canhao_player.player_controlling = false;
	
	points += 3*(4-missing);
	
	end_war(player);
	
func end_war(player):
	
	player.visible = true;
	player.is_on_event = false;
	MinigameEvent.CANNON_WAR.cam.clear_current();
	$"EnemysShip".visible = false;
