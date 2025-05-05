extends Node2D

var _target : Vector2
var _start_pos : Vector2
var _start_scale : Vector2
var _timer : Timer

@onready var sprite : Sprite2D = $Sprite2D

func _init() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(queue_free)
	_timer.start(4)
	_start_scale = Vector2.ONE * randf_range(1,3)
	_target = Vector2(randf_range(-500, 500),randf_range(-500, 500))
	self.position = Vector2.ZERO

func _physics_process(delta: float) -> void:
	self.position = lerp(self.position, _target, 0.05)
	self.global_scale = _start_scale * _timer.time_left/1
