class_name GameManager
extends Node

var player_health: int = 100
var stage: PackedScene = preload("res://scenes/stages/stage_yuuka.tscn")
var title: PackedScene = preload("res://scenes/title_screen.tscn")
var end: PackedScene = preload("res://scenes/end_screen.tscn")
var _is_attacking : bool = false
var has_won = false

signal on_player_hit
signal on_boss_hit
signal on_player_health_changed
signal on_boss_health_changed
signal on_new_card
signal on_timer_update
signal on_attack_start
signal on_attack_end

func _ready():
	on_player_hit.connect(_damage_players)
	on_attack_start.connect(_attack_start)
	on_attack_end.connect(_attack_end)
	
func _damage_players(damage: int):
	player_health -= damage
	on_player_health_changed.emit(player_health)
	if player_health <= 0:
		game_manager.has_won = false
		end_game()

func _attack_start():
	_is_attacking = true
func _attack_end():
	_is_attacking = false

func start_game():
	game_manager.has_won = false
	player_health = 200
	get_tree().call_deferred("change_scene_to_packed", stage)
	
func end_game():
	if _is_attacking:
		await on_attack_end
	get_tree().call_deferred("change_scene_to_packed", end)
	
func go_to_title():
	get_tree().call_deferred("change_scene_to_packed", title)
