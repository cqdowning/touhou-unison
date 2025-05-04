class_name SpellCard
extends Node

var _health: int = 1000
var _time: float = 30
var _damage: int = 10
var _timer: Timer
var _owner: Boss
var _attack_time: float = 1
var can_move : bool = true
var has_clone : bool = false
var clone_spawn_position : Vector2
var move_time : float = 1
const CHARGE : PackedScene = preload("res://scenes/charge_particle.tscn")

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
	game_manager.on_timer_update.emit(_timer.time_left)
	_owner.on_attack_end.emit(self._attack_time)
	pass
func attack1():
	pass
func attack2():
	pass
func attack3():
	pass

func _burst(bullet_count : int, bullet_speed : float, offset : float, spawn_pos : Vector2 = _owner.global_position):
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.straight_shot, bullet_count)
	for i : float in range(0, bullet_count):
		var temp : ProjectileEnemy = bullet_pool[i]
		# Set projectile properties
		temp.set_properties(_damage, bullet_speed)
		temp.spawn()
		temp.launch(spawn_pos, Vector2.DOWN.rotated(2*PI * (i/bullet_count + offset)))

func _burst_curve(bullet_count : int, bullet_speed : float, offset : float, spawn_pos : Vector2 = _owner.global_position, curve : float = 1):
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.curved_shot, bullet_count)
	for i : float in range(0, bullet_count):
		var temp : CurveShot = bullet_pool[i]
		# Set projectile properties
		temp.set_properties(_damage, bullet_speed, curve)
		temp.spawn()
		temp.launch(spawn_pos, Vector2.DOWN.rotated(2*PI * (i/bullet_count + offset)))

func _target_shot(target : int, bullet_speed : float, offset : float, spawn_pos : Vector2 = _owner.global_position):
	var temp : ProjectileEnemy = _owner.get_bullets(Enums.bullet_types.straight_shot, 1).front()
	var direction : Vector2
	match target:
		Enums.players.Reimu:
			direction = _owner.P1.global_position - spawn_pos
		Enums.players.Marisa:
			direction = _owner.P2.global_position - spawn_pos
		_:
			direction = Vector2.DOWN
	temp.set_properties(_damage, bullet_speed)
	temp.spawn(target)
	temp.launch(spawn_pos, direction.rotated(2 * PI * offset))

func _spread_shot(bullet_count : int, bullet_speed : float, start_angle : float, end_angle : float, target : int = -1, spawn_pos : Vector2 = _owner.global_position):
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.straight_shot, bullet_count)
	var direction : Vector2
	match target:
		Enums.players.Reimu:
			direction = _owner.P1.global_position - spawn_pos
		Enums.players.Marisa:
			direction = _owner.P2.global_position - spawn_pos
		_:
			direction = Vector2.DOWN
	for i : float in range(0, bullet_count):
		var temp : ProjectileEnemy = bullet_pool[i]
		# Set projectile properties
		temp.set_properties(_damage, bullet_speed)
		temp.spawn(target)
		temp.launch(spawn_pos, direction.rotated(2.0 * PI * (start_angle + (end_angle - start_angle) * i / bullet_count)))

func _fan_shot(bullet_count : int, bullet_speed : float, start_angle : float, end_angle : float, target : int = -1, spawn_pos : Vector2 = _owner.global_position):
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.straight_shot, bullet_count)
	var direction : Vector2
	match target:
		Enums.players.Reimu:
			direction = _owner.P1.global_position - spawn_pos
		Enums.players.Marisa:
			direction = _owner.P2.global_position - spawn_pos
		_:
			direction = Vector2.DOWN
	for i : float in range(0, bullet_count):
		var temp : ProjectileEnemy = bullet_pool[i]
		# Set projectile properties
		temp.set_properties(_damage, bullet_speed)
		temp.spawn(target)
		temp.launch(spawn_pos, direction.rotated(2.0 * PI * (start_angle + (end_angle - start_angle) * i / bullet_count)))
		await _owner.get_tree().create_timer(0.1).timeout

func damage_card(amnt: float):
	_health -= amnt
	game_manager.on_boss_health_changed.emit(_health)
	if _health <= 0:
		_owner.end_spell() 

func _on_timeout():
	print("SPELL TIMEOUT")
