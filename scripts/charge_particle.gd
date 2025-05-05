extends Node2D

var _target : Vector2
var _start_pos : Vector2
var _start_scale : Vector2
@onready var sprite : Sprite2D = $Sprite2D

func _init() -> void:
	_start_pos = Vector2(randf_range(-200, 200),randf_range(-200, 200))
	_start_scale = Vector2.ONE * randf_range(1,3)
	_target = Vector2.ZERO
	self.position = _start_pos

func change_color(color : Color):
	if sprite == null:
		for c in self.get_children():
			if c.is_class("Sprite2D"):
				sprite = c
				break
	sprite.self_modulate = color

func _physics_process(delta: float) -> void:
	self.position = lerp(self.position, _target, 0.05)
	self.global_scale = _start_scale * abs(self.position-_target)/abs(_start_pos-_target)
	if abs(self.position - _target) < Vector2(5,5):
		queue_free()
