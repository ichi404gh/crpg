extends Node2D


@onready var battle_manager: BattleManager = $BattleManager
@onready var button: Button = $CanvasLayer/Control/Button

const LIGHT_ATTACK = preload("res://data/action_cards/light_attack.tres")
const HEAVY_ATTACK = preload("res://data/action_cards/heavy_attack.tres")
const VERY_FAST_ATTACK = preload("res://data/action_cards/very_fast_attack.tres")


var paused = false

func _ready():
	button.button_down.connect(on_pause_unpause)
	
	var hero = Unit.new()
	hero.unit_name = "Hero"
	hero.hp = 20
	
	var enemy = Unit.new()
	enemy.unit_name = "Enemy"
	enemy.hp = 20
	
	var enemy2 = Unit.new()
	enemy2.unit_name = "Enemy"
	enemy2.hp = 20
	
	battle_manager.set_parties([hero], [enemy,enemy2])

	battle_manager.play_card(hero, enemy, VERY_FAST_ATTACK)
	battle_manager.play_card(enemy, hero, HEAVY_ATTACK)
	battle_manager.play_card(enemy2, hero, LIGHT_ATTACK)
	battle_manager.card_recovered.connect(play_new_action)
	
func play_new_action(card: QueuedAction):
	battle_manager.play_card(card.source, card.target, card.action)

func on_pause_unpause():
	if paused:
		battle_manager.resume()
	else:
		battle_manager.pause()
	paused = !paused

	
