extends Node
class_name DeckManager

const HEAVY_ATTACK = preload("res://data/action_cards/heavy_attack.tres")
const LIGHT_ATTACK = preload("res://data/action_cards/light_attack.tres")
const VERY_FAST_ATTACK = preload("res://data/action_cards/very_fast_attack.tres")

func get_unit_hand(unit: Unit) -> Array[ActionCard]:
	return [LIGHT_ATTACK, HEAVY_ATTACK, VERY_FAST_ATTACK]
