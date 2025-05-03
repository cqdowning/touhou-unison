extends Node2D

@onready var P1 : Player
@onready var P2 : Player
@onready var sprite = $BallSprite
@onready var eventTimer = $Timer
@export var bullet_speed : float

var targetPos : Vector2
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func spawn(bulletSpeed = 1.0, target : Player = null) -> void:
	if target == P1:
		sprite.self_modulate = Color.RED
	elif target == P2:
		sprite.self_modulate = Color.BLUE
	else:
		sprite.self_modulate = Color.GREEN
	bullet_speed = bulletSpeed
	self.show()

func expire() -> void:
	self.hide()
