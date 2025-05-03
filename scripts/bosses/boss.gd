class_name Boss
extends Node2D


@export var red_bullet: PackedScene
@export var yellow_bullet: PackedScene
@export var green_bullet: PackedScene

var _spell_cards: Array[SpellCard]
var _current_spell_card: SpellCard
var _spell_index: int = 0
var _lerp_speed: float = 0.5

var _attack_timer: Timer
var _move_timer: Timer

@onready var hitbox: Area2D = $Hitbox
@onready var _target: Vector2 = self.global_position

func _ready() -> void:
	_attack_timer = Timer.new()
	add_child(_attack_timer)
	_attack_timer.one_shot = false
	_attack_timer.timeout.connect(attack)
	_spell_cards.append(TestCard.new(self))
	hitbox.area_entered.connect(_on_hitbox_entered)
	begin()

func begin():
	_attack_timer.stop()
	#_move_timer.stop()
	next_spell()
	
func next_spell():
	_current_spell_card = _spell_cards[_spell_index]
	_current_spell_card.begin()
	_spell_index += 1
	_attack_timer.wait_time = _current_spell_card._attack_time
	_attack_timer.start(_current_spell_card._attack_time)
	#if _current_spell_card._can_move:
		#_move_timer.start()

func _physics_process(delta: float) -> void:
	if abs(_target - self.global_position) > Vector2(0.1,0.1):
		self.global_position = lerp(self.global_position, _target, _lerp_speed)
	pass

func take_damage(dmg:int) -> void:
	_current_spell_card._health -= dmg
	if _current_spell_card._health <= 0:
		end_spell() 
		
func attack() -> void:
	_current_spell_card.attack()
	_attack_timer.start(_current_spell_card._attack_time)
	pass

func move(pos:Vector2) -> void:
	_target = pos
	

func end_spell() -> void:
	if _spell_index > _spell_cards.size():
		next_spell()
	pass
	
func _on_hitbox_entered(area: Area2D):
	if area is ProjectilePlayer:
		game_manager.on_boss_hit.emit(area.damage)
		_current_spell_card.damage_card(area.damage)
