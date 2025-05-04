class_name TestCard2
extends SpellCard

func _init(owner: Boss) -> void:
	_attack_time = 1
	super._init(owner)
	
func attack():
	super()
	_burst(16, 8, 0)
	await _owner.get_tree().create_timer(0.1).timeout
	_burst(16, 8, 1.0/32)
	
	
