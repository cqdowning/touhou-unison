class_name TestCard3
extends SpellCard
var offset : float
func _init(owner: Boss) -> void:
	offset = 0
	can_move = true
	_attack_time = 0.8
	super._init(owner)
	move_time = 5

func begin():
	_owner.move_target(Vector2(430, 100))
	super()

func attack():
	game_manager.on_attack_start.emit()
	_owner._move_timer.paused = true
	var bullet_count = 16
	var fan_count = 4
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.straight_shot, bullet_count * fan_count)
	var angle = -1.0/10
	for i : float in range(0, bullet_count):
		for j : float in range(0, fan_count):
			var temp : ProjectileEnemy = bullet_pool[i + bullet_count * j]
			# Set projectile properties
			temp.set_properties(_damage, 3)
			temp.spawn()
			temp.launch(_owner.global_position, Vector2.DOWN.rotated(2.0 * PI * (angle + j/(fan_count) + -2 * angle * i / 16 + (angle * offset))))
		await _owner.get_tree().create_timer(0.05).timeout	
	super()
	offset += 1
	_owner._move_timer.paused = false
	
	
