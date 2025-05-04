class_name TestCard4
extends SpellCard
var offset : float
var _curve : float
func _init(owner: Boss) -> void:
	offset = 0
	can_move = true
	_attack_time = 0.8
	super._init(owner)
	move_time = 5
	_curve = 3

func begin():
	_owner.move_target(Vector2(430, 100))
	super()

func attack():
	_burst_curve(64, 6, 0, _owner.global_position, _curve)
	_curve *= -1
	super()
	
	
