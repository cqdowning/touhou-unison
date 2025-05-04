class_name YuukaClone
extends Node2D

@onready var hitbox: Area2D = $Hitbox
@onready var _sprite : Sprite2D = $Sprite2D

var _target : Vector2
var _owner: Boss

@export_category("Character Sprite")
@export var characterSprite_Idle : Texture2D
@export var characterSprite_Move : Texture2D

func _ready() -> void:
	_target = self.global_position

func _physics_process(delta: float) -> void:
	if abs(_target - self.global_position) > Vector2(0.1,0.1):
		self.global_position = lerp(self.global_position, _target, _owner._lerp_speed)
		if _target.x > self.global_position.x:
			_sprite.texture = characterSprite_Move
			_sprite.flip_h = true
		elif _target.x < self.global_position.x:
			_sprite.texture = characterSprite_Move
			_sprite.flip_h = false

func move_target(target : Vector2) -> void:
	_target = target

func spawn(owner: Boss, position: Vector2):
	_owner = owner
	self.global_position = position
	hitbox.area_entered.connect(_on_hitbox_entered)

func _on_hitbox_entered(area: Area2D):
	if area is ProjectilePlayer:
		if _owner._invincible_timer.is_stopped():
			_owner._current_spell_card.damage_card(area.damage)
		area.expire()
