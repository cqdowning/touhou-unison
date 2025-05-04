class_name CurveShot
extends ProjectileEnemy

var velocity : Vector2
var _curve : float
var time:float
# Called when the node enters the scene tree for the first time.
func _ready():
	_curve = 3
	super()

func _physics_process(delta):
	if is_active:
		velocity = velocity.rotated(log(time) * _curve / 250)
		time += delta
		position += velocity
		if (position.x > 1000 or position.x < 0 or position.y < 0 or position.y > 800):
			expire()
			
func set_properties(proj_damage: float, proj_speed: float, curve:float = 1) -> void:
	damage = proj_damage
	speed = proj_speed
	_curve = curve


func launch(spawn_position: Vector2, launch_direction: Vector2) -> void:
	global_position = spawn_position
	direction = launch_direction.normalized()
	velocity = direction * speed
	time = 1
