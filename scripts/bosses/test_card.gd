extends SpellCard

func attack():
	if _frame == 20:
		var new_projectile: ProjectileEnemy = owner.red_bullet.instantiate()
		get_tree().current_scene.add_child(new_projectile)
		
		# Set projectile properties
		new_projectile.set_properties(_damage, 200)
		new_projectile.launch(owner.global_position, Vector2(0, 1))
