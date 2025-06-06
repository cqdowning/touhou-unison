class_name TestCard2
extends SpellCard

func _init(owner: Boss) -> void:
	_health = 3000
	can_move = false
	has_clone = false
	clone_spawn_position = Vector2(owner.global_position.x + 100, owner.global_position.y)
	_attack_time = 1
	super._init(owner)

func begin():
	_owner._move_timer.stop()
	_owner.move_target(Vector2(430, 100))
	super()

func attack():
	game_manager.on_attack_start.emit()
	for i in range(0,16):
		var particle = CHARGE.instantiate()
		particle.change_color(Color.YELLOW)
		_owner.add_child(particle)
		await _owner.get_tree().create_timer(0.01).timeout
	await _owner.get_tree().create_timer(1.5).timeout
	var target : Vector2
	target = Vector2(randf_range(50, 700), randf_range(25, 100))
	
	_burst(16, 8, 0, target)
	await _owner.get_tree().create_timer(0.1).timeout
	_burst(16, 8, 1.0/32, target)
	target = Vector2(randf_range(50, 700), randf_range(25, 100))
	
	await _owner.get_tree().create_timer(0.2).timeout
	_burst(16, 8, 0, target)
	await _owner.get_tree().create_timer(0.1).timeout
	_burst(16, 8, 1.0/32, target)
	target = Vector2(randf_range(50, 700), randf_range(25, 100))
	
	await _owner.get_tree().create_timer(0.2).timeout
	_burst(16, 8, 0, target)
	await _owner.get_tree().create_timer(0.1).timeout
	_burst(16, 8, 1.0/32, target)
	target = Vector2(randf_range(50, 700), randf_range(25, 100))
	
	await _owner.get_tree().create_timer(0.2).timeout
	_burst(16, 8, 0, target)
	await _owner.get_tree().create_timer(0.1).timeout
	_burst(16, 8, 1.0/32, target)
	target = Vector2(randf_range(50, 700), randf_range(25, 100))
	
	super()
	
