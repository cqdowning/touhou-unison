class_name Overlay
extends CanvasLayer

@onready var boss_health_bar: ProgressBar = $BossHealthBar
@onready var player_health_bar: ProgressBar = $PlayerHealthBar
@onready var timer: Label = $Time

func _ready():
	game_manager.on_boss_health_changed.connect(_update_boss_health)
	game_manager.on_player_health_changed.connect(_update_player_health)
	game_manager.on_new_card.connect(_reset_boss_health)
	game_manager.on_timer_update.connect(_update_timer)
	
	player_health_bar.max_value = game_manager.player_health
	player_health_bar.value = game_manager.player_health

func _physics_process(delta: float) -> void:
	pass

func _update_boss_health(new_health: int):
	boss_health_bar.value = new_health
	
func _update_player_health(new_health: int):
	player_health_bar.value = new_health
	
func _reset_boss_health(max_health: int):
	boss_health_bar.max_value = max_health
	boss_health_bar.value = max_health
	
func _update_timer(time_left: float):
	timer.text = str(roundi(time_left))
