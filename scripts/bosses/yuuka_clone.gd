extends Node2D

@onready var hitbox: Area2D = $Hitbox

var _owner: Boss

func spawn(owner: Boss, position: Vector2):
	_owner = owner
	global_position = position

func _on_hitbox_entered(area: Area2D):
	if area is ProjectilePlayer:
		_owner._current_spell_card.damage_card(area.damage)
		area.expire()
