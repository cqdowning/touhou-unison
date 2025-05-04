class_name SoundManager
extends AudioStreamPlayer

var _player_hit: AudioStream = preload("res://SFX/player_hit.ogg")
var _player_shoot: AudioStream = preload("res://SFX/player_shoot.ogg")
var _player_death: AudioStream = preload("res://SFX/death_sound.ogg")
var _enemy_shoot: AudioStream = preload("res://SFX/enemy_shoot.ogg")

var _playback: AudioStreamPlaybackPolyphonic

func _ready() -> void:
	self.bus = "SFX"
	self.max_polyphony = 10
	self.stream = AudioStreamPolyphonic.new()
	self.play()
	_playback = self.get_stream_playback()

func play_player_hit():
	_playback.play_stream(_player_hit, 0, 0, 1, 0, "SFX");

func play_player_shoot():
	_playback.play_stream(_player_shoot, 0, 0, 1, 0, "SFX");

func play_player_death():
	_playback.play_stream(_player_death, 0, 0, 1, 0, "SFX");
	
func play_enemy_shoot():
	_playback.play_stream(_enemy_shoot, 0, 0, 1, 0, "SFX");
