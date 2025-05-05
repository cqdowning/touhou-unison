class_name ProjectileEnemy
extends Projectile

var sprite
@onready var eventTimer : Timer

var targetPos : Vector2

func _ready() -> void:
	for c in self.get_children():
		if c.is_class("Sprite2D"):
			sprite = c
			break
	super()

func spawn(target : int = -1) -> void:
	if target == Enums.players.Reimu:
		sprite.self_modulate = Color.RED
	elif target == Enums.players.Marisa:
		sprite.self_modulate = Color.YELLOW
	else:
		sprite.self_modulate = Color.GREEN
	is_active = true
	_despawn_timer.start()
	self.show()
	sound_manager.play_enemy_shoot()
