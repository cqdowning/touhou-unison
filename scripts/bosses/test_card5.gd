class_name TestCard5
extends SpellCard
var _turn_rate : float = 1.0/64
var offset : float
var _frame : int
func _init(owner: Boss) -> void:
	_health = 2000
	offset = 0
	can_move = false
	_attack_time = 0.3
	super._init(owner)
	_frame = 1

func begin():
	_owner.move_target(Vector2(400, 150))
	super()

func attack():
	game_manager.on_attack_start.emit()
	attack1()
	if _frame % 2 == 0:
		offset += _turn_rate
		if abs(offset) > 0.125:
			_turn_rate *= -1
	if _frame % 14 == 0:
		attack2()
	_frame += 1
	super()
	
func attack1():
	var bullet_count = 80
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.straight_shot, bullet_count)
	var direction = Vector2.DOWN
	var start_angle = 1.0/32
	var end_angle = 1.0 - start_angle
	for i : float in range(0, bullet_count):
		var temp : ProjectileEnemy = bullet_pool[i]
		# Set projectile properties
		temp.set_properties(_damage, 5)
		temp.spawn()
		temp.launch(_owner.global_position, direction.rotated(2.0 * PI * (start_angle + offset + (end_angle - start_angle) * i / bullet_count)))

func attack2():
	_spread_shot(5, 8, 1.0/32, -1.0/32, Enums.players.Reimu)
	_spread_shot(5, 8, 1.0/32, -1.0/32, Enums.players.Marisa)
