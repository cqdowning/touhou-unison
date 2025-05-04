class_name SpellCard
extends Node

var _health: int = 100
var _time: int = 30
var _damage: int = 20
var _timer: Timer
var _owner: Boss
var _attack_time: float = 1
var _can_move : bool = true

func _init(owner: Boss):
	_owner = owner
	_timer = Timer.new()
	_owner.add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timeout)
	
func begin():
	_timer.start(_time)
	game_manager.on_new_card.emit(_health)

func attack():
	pass
func attack1():
	pass
func attack2():
	pass
func attack3():
	pass

func _burst(bullet_count : int, bullet_speed : float, offset : float):
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.straight_shot, bullet_count)
	for i : float in range(0, bullet_count):
		var temp : ProjectileEnemy = bullet_pool[i]
		# Set projectile properties
		temp.set_properties(_damage, bullet_speed)
		temp.spawn()
		temp.launch(_owner.global_position, Vector2.DOWN.rotated(2*PI * (i/bullet_count + offset)))

func _target_shot(target : int, bullet_speed : float, offset : float):
	var temp : ProjectileEnemy = _owner.get_bullets(Enums.bullet_types.straight_shot, 1).front()
	var direction : Vector2
	match target:
		Enums.players.Reimu:
			direction = _owner.P1.global_position - _owner.global_position
		Enums.players.Marisa:
			direction = _owner.P2.global_position - _owner.global_position
		_:
			direction = Vector2.DOWN
	temp.set_properties(_damage, bullet_speed)
	temp.spawn(target)
	temp.launch(_owner.global_position, direction.rotated(2 * PI * offset))

func _spread_shot(bullet_count : int, bullet_speed : float, start_angle : float, end_angle : float, target : int = -1):
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.straight_shot, bullet_count)
	var direction : Vector2
	match target:
		Enums.players.Reimu:
			direction = _owner.P1.global_position - _owner.global_position
		Enums.players.Marisa:
			direction = _owner.P2.global_position - _owner.global_position
		_:
			direction = Vector2.DOWN
	print((end_angle - start_angle) / bullet_count)
	for i : float in range(0, bullet_count):
		var temp : ProjectileEnemy = bullet_pool[i]
		# Set projectile properties
		temp.set_properties(_damage, bullet_speed)
		temp.spawn(target)
		temp.launch(_owner.global_position, direction.rotated(2.0 * PI * (start_angle + (end_angle - start_angle) * i / bullet_count)))

func damage_card(amnt: float):
	_health -= amnt
	game_manager.on_boss_health_changed.emit(_health)

func _on_timeout():
	pass # End the game
