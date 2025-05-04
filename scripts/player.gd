class_name Player
extends CharacterBody2D

@export_category("ID")
@export var player_id: int = 1

@export_category("Stats")
@export var damage: int = 10
@export var speed: float = 450.0
@export var focus_speed: float = 250.0
@export var shoot_rate: int = 4
@export var shoot_speed: float = 600.0
@export var shoot_offset: float = 10.0

@export_category("Projectile")
@export var projectile: PackedScene

var _shooting: bool = false
var _shoot_frame: int = 0
var _current_speed: float = 0
var _move_input: Vector2

@onready var hitbox: Area2D = $Hitbox
@onready var pushbox: Area2D = $Pushbox

func _ready():
	hitbox.area_entered.connect(_on_hitbox_entered)

func _process(delta):
	

	_move_input.x = Input.get_action_strength(str("p", player_id, "_right")) - Input.get_action_strength(str("p", player_id, "_left"))
	_move_input.y = Input.get_action_strength(str("p", player_id, "_down")) - Input.get_action_strength(str("p", player_id, "_up"))
	
	_current_speed = speed
	if Input.is_action_pressed(str("p", player_id, "_focus")):
		_current_speed = focus_speed
	
	if Input.is_action_just_pressed(str("p", player_id, "_shoot")):
		_shooting = true
	
	if Input.is_action_just_released(str("p", player_id, "_shoot")):
		_shooting = false

func _physics_process(_delta):
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
		# Create and setup projectile
		for i in range(-1, 2, 2):
			var new_projectile: Projectile = projectile.instantiate()
			get_tree().current_scene.add_child(new_projectile)
			
			# Set projectile properties
			new_projectile.set_properties(damage, shoot_speed)
			new_projectile.launch(Vector2(self.global_position.x + shoot_offset*i, self.global_position.y - 50), Vector2(0, -1))
		_shoot_frame = 0

func _on_hitbox_entered(area: Area2D):
	if area is Projectile:
		game_manager.on_player_hit.emit(area.damage)
		
