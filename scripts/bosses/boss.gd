class_name Boss
extends Node2D

var _spell_cards: Array[SpellCard]
var _current_spell_card: SpellCard
var _spell_index: int = 0
var _lerp_speed: float = 0.08

var _attack_timer: Timer
var _move_timer: Timer
var _pool_1: Node2D
var _pool_2: Node2D
var _invincible_timer: Timer
var _clone: YuukaClone

const CLONE: PackedScene = preload("res://scenes/bosses/yuuka_clone.tscn")

@export_category("Character Sprite")
@export var characterSprite_Idle : Texture2D
@export var characterSprite_Move : Texture2D

signal on_attack_end

@onready var P1 : Player = get_tree().get_first_node_in_group("Reimu")
@onready var P2 : Player = get_tree().get_first_node_in_group("Marisa")
@onready var _sprite : Sprite2D = $Sprite2D

@onready var hitbox: Area2D = $Hitbox
@onready var _target: Vector2 = self.global_position

func _ready() -> void:
	_attack_timer = Timer.new()
	add_child(_attack_timer)
	_attack_timer.one_shot = true
	_attack_timer.timeout.connect(attack)
	_move_timer = Timer.new()
	add_child(_move_timer)
	_move_timer.wait_time = 1
	_move_timer.one_shot = true
	_move_timer.timeout.connect(move)
	_invincible_timer = Timer.new()
	add_child(_invincible_timer)
	_invincible_timer.wait_time = 1
	_invincible_timer.one_shot = true
	_invincible_timer.start()
	_pool_1 = Node2D.new()
	add_child(_pool_1)
	_init_pool(_pool_1, Enums.bullet_types.straight_shot, 64)
	_pool_2 = Node2D.new()
	add_child(_pool_2)
	_init_pool(_pool_2, Enums.bullet_types.curved_shot, 64)
	_spell_cards.append(TestCard.new(self))
	_spell_cards.append(TestCard2.new(self))
	_spell_cards.append(TestCard3.new(self))
	_spell_cards.append(TestCard4.new(self))
	_spell_cards.append(TestCard5.new(self))
	_spell_cards.append(TestCard6.new(self))
	on_attack_end.connect(_attack_timer.start)
	hitbox.area_entered.connect(_on_hitbox_entered)
	begin()

func begin():
	_attack_timer.stop()
	_move_timer.stop()
	next_spell()
	
func next_spell():
	_invincible_timer.start()
	_current_spell_card = _spell_cards[_spell_index]
	_current_spell_card.begin()
	_spell_index += 1
	_attack_timer.wait_time = _current_spell_card._attack_time
	_attack_timer.start(_current_spell_card._attack_time)
	if _current_spell_card.can_move:
		_move_timer.wait_time = _current_spell_card.move_time
		_move_timer.start()
	if _current_spell_card.has_clone:
		_spawn_clone(_current_spell_card.clone_spawn_position)

func _physics_process(delta: float) -> void:
	if abs(_target - self.global_position) > Vector2(0.1,0.1):
		self.global_position = lerp(self.global_position, _target, _lerp_speed)
		if _target.x > self.global_position.x:
			_sprite.texture = characterSprite_Move
			_sprite.flip_h = true
		elif _target.x < self.global_position.x:
			_sprite.texture = characterSprite_Move
			_sprite.flip_h = false
	else:
		_sprite.texture = characterSprite_Idle
		if _move_timer.is_stopped() and _current_spell_card.can_move:
			_move_timer.start()
	game_manager.on_timer_update.emit(_current_spell_card._timer.time_left)

func attack() -> void:
	_current_spell_card.attack()
	pass

func move() -> void:
	_target = Vector2(randf_range(50, 700), randf_range(25, 200))

func move_target(target : Vector2) -> void:
	_target = target

func end_spell() -> void:
	if _current_spell_card.has_clone:
		_despawn_clone()
	_attack_timer.stop()
	_move_timer.stop()
	_current_spell_card._timer.stop()
	if _spell_index < _spell_cards.size():
		next_spell()
	else:
		game_manager.has_won = true
		game_manager.end_game()

func _spawn_clone(position: Vector2):
	_clone = CLONE.instantiate()
	add_child(_clone)
	_clone.top_level = true
	_clone.spawn(self, position)
	
func _despawn_clone():
	_clone.queue_free()

func move_clone(target: Vector2):
	_clone.move_target(target)

func _init_pool(pool : Node, bullet_type : Enums.bullet_types, initial : int) -> void:
	pool.set_as_top_level(true)
	add_bullets(pool, bullet_type, initial)

func get_bullets(bullet_type : Enums.bullet_types, count : int) -> Array[ProjectileEnemy]:
	var pool : Node2D
	var output : Array[ProjectileEnemy]
	var bullet_count = 0
	match bullet_type:
		Enums.bullet_types.straight_shot:
			pool = _pool_1
		Enums.bullet_types.curved_shot:
			pool = _pool_2
	for bullet : ProjectileEnemy in pool.get_children():
		if not bullet.is_active:
			output.append(bullet)
			bullet_count += 1
			if bullet_count >= count:
				return output
	output.append_array(add_bullets(pool, bullet_type, 20 + (count - bullet_count)))
	return output

func add_bullets(pool : Node, bullet_type : Enums.bullet_types, count : int) -> Array[ProjectileEnemy]:
	var bullet : PackedScene
	var output : Array[ProjectileEnemy]
	match bullet_type:
		Enums.bullet_types.straight_shot:
			bullet = load("res://scenes/projectiles/ball.tscn")
		Enums.bullet_types.curved_shot:
			bullet = load("res://scenes/projectiles/curve.tscn")
	for i in range(0, count):
		var temp : ProjectileEnemy = bullet.instantiate()
		temp.expire()
		pool.add_child(temp)
		output.append(temp)
	return output
	
func _on_hitbox_entered(area: Area2D):
	if area is ProjectilePlayer:
		if _invincible_timer.is_stopped():
			_current_spell_card.damage_card(area.damage)
		area.expire()
