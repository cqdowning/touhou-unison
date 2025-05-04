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
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timeout)
	
func begin():
	_timer.start(_time)

func attack():
	pass

func _burst(bullet_count : int, bullet_speed : float, offset : float):
	var bullet_pool : Array[ProjectileEnemy] = _owner.get_bullets(Enums.bullet_types.straight_shot, bullet_count)
	for i : float in range(0, bullet_count):
		var temp : ProjectileEnemy = bullet_pool[i]
		# Set projectile properties
		temp.set_properties(_damage, bullet_speed)
		temp.spawn()
		temp.launch(_owner.global_position, Vector2.DOWN.rotated(2*PI * (i/bullet_count + offset)))

func _on_timeout():
	pass # End the game
