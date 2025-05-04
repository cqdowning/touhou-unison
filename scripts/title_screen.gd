class_name TitleScreen
extends Node2D

@onready var start_btn: Button = $Start

func _ready():
	start_btn.pressed.connect(_start_game)
	
func _process(delta):
	if Input.is_action_pressed("start_game"):
		_start_game()
	
func _start_game():
	game_manager.start_game()
	
