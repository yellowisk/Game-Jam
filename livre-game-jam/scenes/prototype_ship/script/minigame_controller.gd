extends Node3D

signal finished_barrel
signal finished_timao

@export var points = 0;

@onready var ENEMY_SHIP = $"EnemysShip";
@onready var CANNON_PLAYER = load("res://scenes/minigames/cannon_minigame/scripts/cannon_player.gd")

@onready var MinigameEvent =  {
	CANNON_WAR = {
		start = Callable(self, "start_war"),
		end = Callable(self, "end_war"),
		cam = $"Cannons/Camera3D",
	},
	BARREL = {
		start = Callable(self, "start_barrel"),
		end = Callable(self, "end_barrel"),
		cam = $"BarrilGame/SpringArm3D/Camera3D",
	},
	TIMAO = {
		start = Callable(self, "start_timao"),
		end = Callable(self, "end_timao"),
		cam = $"BarrilGame/SpringArm3D/Camera3D",
	}
}

@onready var EventList = ["TIMAO", "CANNON_WAR", "BARREL"]


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
	if is_multiplayer_authority():
		await get_tree().create_timer(10).timeout;
		minigame_loop();

	

func minigame_loop():
	while true:
		if Lobby.CURRENT_EVENT:
			await get_tree().create_timer(randi_range(12,22)).timeout
			
		Lobby.set_event.rpc(EventList[randi() % EventList.size()])
		await get_tree().create_timer(randi_range(12,22)).timeout

func _on_cannon_start_body_entered(body):
	if body.is_in_group("players") and Lobby.CURRENT_EVENT == "CANNON_WAR":
		body.action = Callable(MinigameEvent.CANNON_WAR.start)
		
func _on_cannon_start_body_exited(body):
	if body.is_in_group("players"):
		body.action = null;
	
func start_war(player):
	player.visible = false;
	player.is_on_event = true;
	MinigameEvent.CANNON_WAR.cam.make_current();
	var canhao_player = $"../Ship/canhaoMinigame";
	canhao_player.player_controlling = true;
	
	var missing = await ENEMY_SHIP.start_minigame();
	
	canhao_player.player_controlling = false;
	
	var p = 3*(4-missing);
	Lobby.score.rpc(p);
	
	end_war(player);
	
func end_war(player: Node3D):
	player.visible = true;
	player.is_on_event = false;
	player.get_node("SpringArm3D/Camera3D").make_current();
	Lobby.end_event.rpc("CANNON_WAR")
	
func start_barrel(player: Node3D):
	player.visible = false;
	player.is_on_event = true;
	MinigameEvent.BARREL.cam.make_current();
	$BarrilGame/barrel.player_controlling = true;
	$BarrilGame/Timer.start();
	
	await finished_barrel;
	
	$BarrilGame/Timer.stop();
	$BarrilGame/barrel.player_controlling = false;
	player.visible = true;
	player.is_on_event = false;
	player.get_node("SpringArm3D/Camera3D").make_current();
	
	Lobby.score($BarrilGame/barrel.points);
	$BarrilGame/barrel.points = 0;
	
	Lobby.end_event.rpc("BARREL");

func start_timao(player: CharacterBody3D):
	player.visible = false;
	player.is_on_event = true;
	MinigameEvent.TIMAO.cam.make_current();
	$"/root/Main/Ship".player_controlled = true;
	
	await finished_timao;
	
	player.visible = true;
	player.is_on_event = false;
	player.get_node("SpringArm3D/Camera3D").make_current();
	
	Lobby.score(15);	
	Lobby.end_event.rpc("TIMAO");

func _on_barrel_start_body_entered(body):
	if body.is_in_group("players") and Lobby.CURRENT_EVENT == "BARREL":
		body.action = Callable(MinigameEvent.BARREL.start)
		
func _on_barrel_start_body_exited(body):
	if body.is_in_group("players"):
		body.action = null;

func _on_timao_start_body_entered(body):
	if body.is_in_group("players") and Lobby.CURRENT_EVENT == "TIMAO":
		body.action = Callable(MinigameEvent.TIMAO.start)


func _on_timao_start_body_exited(body):
	if body.is_in_group("players"):
		body.action = null;
