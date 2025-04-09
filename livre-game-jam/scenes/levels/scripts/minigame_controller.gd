extends Node

@onready var timer_scene := preload("res://scenes/levels/scenes/starting_timer.tscn")
@onready var event_ticket_scene := preload("res://scenes/hud/scenes/event_ticket.tscn")

@onready var cannon_war_scene := preload("res://scenes/minigames/cannon_war_minigame/cannon_war_controller.tscn")
@onready var timao_scene := preload("res://scenes/minigames/timao_minigame/timao_minigame.tscn")

@export_file("*.json") var level_config := "res://scenes/levels/configs/default.json"

var event_list = []
var event_counter = 0
@export var minigames_list = []

func _ready() -> void:
	if is_multiplayer_authority():
		Signals.start_minigame.connect(start_minigame)
		Signals.end_minigame.connect(end_minigame)

		var json_as_text = FileAccess.get_file_as_string(level_config)
		
		var json = JSON.new()
		var error = json.parse(json_as_text)	
		if error == OK:
			var data_received = json.data
			if typeof(data_received) == TYPE_DICTIONARY:
				event_list = data_received["minigames"]
			else:
				print("Unexpected data")
		else:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_as_text, " at line ", json.get_error_line())
		
		for event in event_list:
			print(event)
			match event["type"]:
				"cannon_war":
					var timer_instance = timer_scene.instantiate()
					add_child(timer_instance)
					timer_instance.config(event)

func start_minigame(event):
	start_minigame_rpc.rpc(event["duration"], event["type"])
	
@rpc("authority", "call_local")
func start_minigame_rpc(duration, type):
	print("Starting minigame")
	var obj = cannon_war_scene.instantiate()
	obj.id = type + "_" + str(event_counter)
	obj.duration = duration
	obj.type = type
	event_list.append(obj)
	get_parent().add_child(obj)
	var event_ticket_instance = event_ticket_scene.instantiate()
	get_parent().get_node("LevelHud/Container/HBoxContainer").add_child(event_ticket_instance)
	event_ticket_instance.config_ticket(obj.id, obj.type, obj.duration)

func end_minigame(id):
	end_minigame_rpc.rpc(id)
	
@rpc("authority", "call_local")
func end_minigame_rpc(id):
	print("Ending minigame")
	pass
	
