class_name TestCard6
extends SpellCard

var offset : float
var _frame : int
var flip : bool

func _init(owner: Boss) -> void:
	flip = false
	can_attack = false
	_health = 2500
	offset = 0
	can_move = false
	super._init(owner)

func begin():
	super()
	_owner._attack_timer.stop()
	_owner.move_target(Vector2(400, 150))
	await _owner.get_tree().create_timer(1.5).timeout
	_owner._spawn_clone(Vector2(400, 150))
	_owner.move_target(Vector2(200, 150))
	_owner.move_clone(Vector2(600, 150))
	await _owner.get_tree().create_timer(1).timeout
	has_clone = true
	can_attack = true
	attack()

func attack():
	if can_attack:
		if flip:
			_spread_shot(9, 3, -1.0/16, 1.0/16, Enums.players.Reimu, _owner.global_position)
			_spread_shot(9, 3, -1.0/16, 1.0/16, Enums.players.Marisa, _owner._clone.global_position)
			_burst(16, 4, 0, _owner.global_position)
		else:
			_spread_shot(9, 3, -1.0/16, 1.0/16, Enums.players.Reimu, _owner._clone.global_position)
			_spread_shot(9, 3, -1.0/16, 1.0/16, Enums.players.Marisa, _owner.global_position)
			_burst(16, 4, 0, _owner._clone.global_position)
		flip = !flip
		super()
