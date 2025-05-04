class_name GameManager
extends Node

var player_health: int = 100
var stage: PackedScene = preload("res://scenes/stages/stage_yuuka.tscn")
var title: PackedScene = preload("res://scenes/title_screen.tscn")

signal on_player_hit
signal on_boss_hit
signal on_player_health_changed
signal on_boss_health_changed
signal on_new_card
signal on_timer_update

func _ready():
	on_player_hit.connect(_damage_players)
	
func _damage_players(damage: int):
	player_health -= damage
	on_player_health_changed.emit(player_health)
	if player_health <= 0:
		end_game()
		
func start_game():
	player_health = 100
	get_tree().call_deferred("change_scene_to_packed", stage)
	
func end_game():
	get_tree().call_deferred("change_scene_to_packed", title)
