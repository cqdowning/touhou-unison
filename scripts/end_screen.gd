class_name EndScreen
extends Node2D

@onready var title: Button = $Title
@onready var report: Label = $Report

func _ready():
	title.pressed.connect(_title)
	update_report()
	
func _process(delta):
	if Input.is_action_pressed("start_game"):
		_title()
	
func _title():
	game_manager.go_to_title()
	
func update_report():
	if game_manager.has_won:
		report.text = "You won!"
	else:
		report.text = "You lost!"
