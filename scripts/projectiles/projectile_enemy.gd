class_name ProjectileEnemy
extends Projectile

@onready var P1 : Player
@onready var P2 : Player
var sprite
@onready var eventTimer : Timer

var targetPos : Vector2

func _ready() -> void:
	for c in self.get_children():
		print(c.get_class())
		if c.is_class("Sprite2D"):
			sprite = c
			break
	super()

func spawn(target : int = -1) -> void:
	if target == Enums.players.Reimu:
		sprite.self_modulate = Color.RED
	elif target == Enums.players.Marisa:
		sprite.self_modulate = Color.BLUE
	else:
		sprite.self_modulate = Color.GREEN
	is_active = true
	_despawn_timer.start()
	self.show()
