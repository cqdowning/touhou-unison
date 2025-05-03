class_name TestCard
extends SpellCard

@onready var ball : PackedScene

func _init(owner: Boss) -> void:
	ball = preload("res://scenes/projectiles/ball.tscn")
	super._init(owner)
	
func attack():
	for i : float in range(0, 16):
		var temp: ProjectileEnemy = ball.instantiate()
		_owner.add_child(temp)
		# Set projectile properties
		temp.set_properties(_damage, 10)
		temp.launch(_owner.global_position, Vector2.DOWN.rotated(2*PI * i/16.0))
		temp = ball.instantiate()
		_owner.add_child(temp)
		# Set projectile properties
		temp.set_properties(_damage, 7)
		temp.launch(_owner.global_position, Vector2.DOWN.rotated(2*PI * (i/16.0 + 1/32.0)))
