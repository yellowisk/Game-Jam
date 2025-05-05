extends CharacterBody3D

class_name Controllable

@export var player_controlling := -1

@rpc("any_peer")
func set_player_controlling(player_controlling):
	self.player_controlling = player_controlling
	
