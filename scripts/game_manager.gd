class_name GameManager
extends Node

var player_health: int = 100

signal on_player_hit
signal on_boss_hit
signal on_player_health_changed
signal on_boss_health_changed
signal on_new_card

func _ready():
	on_player_hit.connect(_damage_players)
	
func _damage_players(damage: int):
	player_health -= damage
	on_player_health_changed.emit(player_health)
	if player_health <= 0:
		_end_game()
	
func _end_game():
	print("Game Over!")
