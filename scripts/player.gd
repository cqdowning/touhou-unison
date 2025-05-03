class_name Player
extends CharacterBody2D

@export_category("ID")
@export var player_id: int = 1

@export_category("Stats")
@export var damage: float = 10.0
@export var speed: float = 450.0
@export var focus_speed: float = 250.0

func _process(delta):
	var move_input = Vector2()

	move_input.x = Input.get_action_strength(str("p", player_id, "_right")) - Input.get_action_strength(str("p", player_id, "_left"))
	move_input.y = Input.get_action_strength(str("p", player_id, "_down")) - Input.get_action_strength(str("p", player_id, "_up"))
	
	var current_speed = speed
	if Input.is_action_pressed(str("p", player_id, "_focus")):
		current_speed = focus_speed
	
	velocity = move_input.normalized() * current_speed

func _physics_process(_delta):
	# Apply movement
	move_and_slide()
