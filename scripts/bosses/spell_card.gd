class_name SpellCard
extends Node

var _health: int = 1000
var _time: float = 30
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
	game_manager.on_timer_update.emit(_timer.time_left)

func _burst(bullet_count : int, bullet_speed : float, offset : float):
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.straight_shot, bullet_count)
	for i : float in range(0, bullet_count):
		var temp : ProjectileEnemy = bullet_pool[i]
		# Set projectile properties
		temp.set_properties(_damage, bullet_speed)
		temp.spawn()
		temp.launch(_owner.global_position, Vector2.DOWN.rotated(2*PI * (i/bullet_count + offset)))

func damage_card(amnt: float):
	_health -= amnt
	game_manager.on_boss_health_changed.emit(_health)
	if _health <= 0:
		_owner.end_spell() 

func _on_timeout():
	print("SPELL TIMEOUT")
