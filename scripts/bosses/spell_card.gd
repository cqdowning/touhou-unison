class_name SpellCard
extends Node

var _health: int = 100
var _time: int = 30
var _damage: int = 20
var _timer: Timer
var _owner: Boss
var _frame: int = 0

func _init(owner: Boss):
	_owner = owner
	_timer = Timer.new()
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timeout)
	
func begin():
	_timer.start(_time)

# Called every fixed process frame
func attack():
	pass

func _on_timeout():
	pass # End the game
