class_name TestCard
extends SpellCard

func _init(owner: Boss) -> void:
	_attack_time = 1
	super._init(owner)
	
func attack():
	_burst(16, 10, 0)
	_burst(16, 9, 1.0/32)
	
