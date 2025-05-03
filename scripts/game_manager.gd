class_name GameManager
extends Node

@export var player_health: int = 0

signal on_player_hit

func _ready():
	on_player_hit.connect(_damage_players)
	
func _damage_players(damage: int):
	player_health -= damage
	if player_health <= 0:
		_end_game()
	
func _end_game():
	print("Game Over!")
