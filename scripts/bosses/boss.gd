class_name Boss
extends Node2D

@export var spell_cards: Array[SpellCard]

@export var red_bullet: PackedScene
@export var yellow_bullet: PackedScene
@export var green_bullet: PackedScene

var _current_spell_card: SpellCard
var _spell_index: int = 0

func begin():
	next_spell()
	
func next_spell():
	_current_spell_card = spell_cards[_current_spell_card].init(self)
	_current_spell_card.begin()
	_spell_index += 1

func _physics_process(delta: float) -> void:
	_current_spell_card.attack()
