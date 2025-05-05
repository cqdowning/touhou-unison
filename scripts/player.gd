class_name Player
extends CharacterBody2D

@export_category("ID")
@export var player_id: int = 1

@export_category("Stats")
@export var damage: int = 5
@export var speed: float = 450.0
@export var focus_speed: float = 250.0
@export var shoot_rate: int = 4
@export var shoot_speed: float = 15.0
@export var shoot_offset: float = 10.0
@export var invincible_frames_amount: int = 120

@export_category("Projectile")
@export var projectile: PackedScene

@export_category("Character Sprite")
@export var characterSprite_Idle : Texture2D
@export var characterSprite_Move : Texture2D

const HIT : PackedScene = preload("res://scenes/hit_particle.tscn")

var _shooting: bool = false
var _shoot_frame: int = 0
var _current_speed: float = 0
var _move_input: Vector2
var _pool: Node2D
var _invincible_frames: int = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var pushbox: Area2D = $Pushbox

func _ready():
	hitbox.area_entered.connect(_on_hitbox_entered)
	_pool = Node2D.new()
	add_child(_pool)
	_init_pool(_pool, 32)
	

func _process(delta):
	_move_input.x = Input.get_action_strength(str("p", player_id, "_right")) - Input.get_action_strength(str("p", player_id, "_left"))
	_move_input.y = Input.get_action_strength(str("p", player_id, "_down")) - Input.get_action_strength(str("p", player_id, "_up"))
	
	_current_speed = speed
	hitbox.visible = false
	
	if _move_input.x > 0:
		sprite.texture = characterSprite_Move
		sprite.flip_h = true
	elif _move_input.x < 0:
		sprite.texture = characterSprite_Move
		sprite.flip_h = false
	else:
		sprite.texture = characterSprite_Idle
		sprite.flip_h = false
	
	if Input.is_action_pressed(str("p", player_id, "_focus")):
		_current_speed = focus_speed
		hitbox.visible = true
	
	if Input.is_action_just_pressed(str("p", player_id, "_shoot")):
		_shooting = true
	
	if Input.is_action_just_released(str("p", player_id, "_shoot")):
		_shooting = false

func _physics_process(_delta):
	_invincible_frames = clampi(_invincible_frames - 1, 0, invincible_frames_amount)
	if _invincible_frames != 0 and _invincible_frames % 6 == 0:
		self.visible = !self.visible
	else:
		self.visible = true
	velocity = _move_input.normalized() * _current_speed
	for area: Area2D in pushbox.get_overlapping_areas():
		if area.owner is Player:
			var other: Player = area.owner
			var other_vel = other.velocity
			if self.velocity.x > 0:
				if other.global_position.x > self.global_position.x:
					self.velocity.x = (other_vel.x + self.velocity.x) / 2
					other.global_position.x += self.get_position_delta().x
			elif self.velocity.x < 0:
				if other.global_position.x < self.global_position.x:
					self.velocity.x = (other_vel.x + self.velocity.x) / 2
					other.global_position.x += self.get_position_delta().x
			if self.velocity.y > 0:
				if other.global_position.y > self.global_position.y:
					self.velocity.y = (other_vel.y + self.velocity.y) / 2
					other.global_position.y += self.get_position_delta().y
			elif self.velocity.y < 0:
				if other.global_position.y < self.global_position.y:
					self.velocity.y = (other_vel.y + self.velocity.y) / 2
					other.global_position.y += self.get_position_delta().y
	
	# Apply movement
	move_and_slide()
	
	if _shooting:
		_shoot()

func _shoot():
	_shoot_frame += 1
	if _shoot_frame == shoot_rate:
		sound_manager.play_player_shoot()
		# Create and setup projectile
		var bullets : Array[ProjectilePlayer] = get_bullets(2)
		for i in range(-1, 2, 2):
			var new_projectile: Projectile = bullets[(i+1)/2]
			# Set projectile properties
			new_projectile.set_properties(damage, shoot_speed)
			new_projectile.spawn()
			new_projectile.launch(Vector2(self.global_position.x + shoot_offset*i, self.global_position.y - 50), Vector2(0, -1))
		_shoot_frame = 0

func _init_pool(pool : Node, initial : int) -> void:
	pool.set_as_top_level(true)
	add_bullets(pool, initial)

func get_bullets(count : int) -> Array[ProjectilePlayer]:
	var output : Array[ProjectilePlayer]
	var bullet_count = 0
	for bullet : ProjectilePlayer in _pool.get_children():
		if not bullet.is_active:
			output.append(bullet)
			bullet_count += 1
			if bullet_count >= count:
				return output
	output.append_array(add_bullets(_pool, 8 + (count - bullet_count)))
	return output

func add_bullets(pool : Node, count : int) -> Array[ProjectilePlayer]:
	var output : Array[ProjectilePlayer]
	for i in range(0, count):
		var temp : ProjectilePlayer = projectile.instantiate()
		temp.expire()
		pool.add_child(temp)
		output.append(temp)
	return output

func hit_particles():
	for i in range(0,16):
		var particle = HIT.instantiate()
		add_child(particle)
		particle.global_position = self.global_position

func _on_hitbox_entered(area: Area2D):
	if area is Projectile and _invincible_frames == 0:
		#hit_particles()
		game_manager.on_player_hit.emit(area.damage)
		sound_manager.play_player_hit()
		_invincible_frames = invincible_frames_amount
		
