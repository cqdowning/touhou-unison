class_name TestCard
extends SpellCard

func _init(owner: Boss) -> void:
	_attack_time = 1.5
	super._init(owner)
	
func attack():
	super()
	#_burst(16, 8, 0)
	#_burst(16, 6, 1.0/32)
	_spread_shot(8, 3, -1.0/16, 1.0/16, Enums.players.Reimu)
	_spread_shot(8, 3, -1.0/16, 1.0/16, Enums.players.Marisa)
	_target_shot(Enums.players.Reimu, 5, 0)
	_target_shot(Enums.players.Reimu, 4.5, 0)
	_target_shot(Enums.players.Reimu, 4, 0)
	_target_shot(Enums.players.Reimu, 3.5, 0)
	_target_shot(Enums.players.Reimu, 3, 0)
	_target_shot(Enums.players.Marisa, 5, 0)
	_target_shot(Enums.players.Marisa, 4.5, 0)
	_target_shot(Enums.players.Marisa, 4, 0)
	_target_shot(Enums.players.Marisa, 3.5, 0)
	_target_shot(Enums.players.Marisa, 3, 0)
	
