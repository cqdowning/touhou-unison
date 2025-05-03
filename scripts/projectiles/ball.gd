class_name Ball
extends ProjectileEnemy

@onready var P1 : Player
@onready var P2 : Player
@onready var sprite = $BallSprite
@onready var eventTimer = $Timer

var targetPos : Vector2
func _ready() -> void:
	spawn()
	pass

func _physics_process(delta: float) -> void:
	position += direction * speed

func spawn(bulletSpeed = 1.0, target : int = -1) -> void:
	if target == Enums.players.Reimu:
		sprite.self_modulate = Color.RED
	elif target == Enums.players.Marisa:
		sprite.self_modulate = Color.BLUE
	else:
		sprite.self_modulate = Color.GREEN
	speed = bulletSpeed
	self.show()

func expire() -> void:
	self.hide()
