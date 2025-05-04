class_name ProjectileEnemy
extends Projectile

@onready var P1 : Player
@onready var P2 : Player
var sprite
@onready var eventTimer : Timer
var is_active : bool

var targetPos : Vector2

func _ready() -> void:
	for c in self.get_children():
		print(c.get_class())
		if c.is_class("Sprite2D"):
			sprite = c
			break
	is_active = false
	super()
	_despawn_timer.wait_time = 10
	_despawn_timer.stop()

func _physics_process(delta: float) -> void:
	if is_active:
		position += direction * speed
		if (position.x > 1000 or position.x < 0 or position.y < 0 or position.y > 500):
			expire()

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

func expire() -> void:
	is_active = false
	self.hide()
	
func _on_despawn_timeout() -> void:
	expire()
