class_name YuukaClone
extends Node2D

@onready var hitbox: Area2D = $Hitbox

var _owner: Boss

func spawn(owner: Boss, position: Vector2):
	_owner = owner
	self.global_position = position
	hitbox.area_entered.connect(_on_hitbox_entered)

func _on_hitbox_entered(area: Area2D):
	if area is ProjectilePlayer:
		if _owner._invincible_timer.is_stopped():
			_owner._current_spell_card.damage_card(area.damage)
		area.expire()
