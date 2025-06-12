extends Node2D

@onready var battle_manager: BattleManager = $BattleManager
@onready var deck_manager: DeckManager = $DeckManager
@onready var button: Button = $CanvasLayer/Control/Button
@onready var action_bar: HBoxContainer = $CanvasLayer/Control/ActionBar

const LIGHT_ATTACK = preload("res://data/action_cards/light_attack.tres")
const HEAVY_ATTACK = preload("res://data/action_cards/heavy_attack.tres")
const VERY_FAST_ATTACK = preload("res://data/action_cards/very_fast_attack.tres")

signal player_plays_card(card: ActionCard)

var paused = false

var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []


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
	
	player_party.append(hero)
	enemy_party.append(enemy)
	enemy_party.append(enemy2)
	
	battle_manager.set_parties(player_party, enemy_party)

	
	battle_manager.play_card(hero, hero, ActionCard.build("Surprised!", 0, randf_range(0, 0.4)))
	battle_manager.play_card(enemy, enemy, ActionCard.build("Surprised!", 0, randf_range(0, 0.4)))
	battle_manager.play_card(enemy2, enemy2, ActionCard.build("Surprised!", 0, randf_range(0, 0.4)))
	
	battle_manager.card_recovered.connect(play_new_action)
	
func play_new_action(card: QueuedAction):
	var hand = deck_manager.get_unit_hand(card.source)

	if card.source in player_party:
		battle_manager.pause()
		
		show_hand(hand)
		var played_card = await wait_for_card_played()
		# handle card targeting
		
		battle_manager.play_card(card.source, card.target, played_card)
		
		battle_manager.resume()
	else:
		
		battle_manager.play_card(card.source, card.target, hand[randi_range(0, hand.size() - 1)])

func on_pause_unpause():
	if paused:
		battle_manager.resume()
	else:
		battle_manager.pause()
	paused = !paused

func show_hand(hand: Array[ActionCard]):
	

	for card in hand:
		const CARD_UI = preload("res://scenes/ui/card_ui.tscn")
		var card_ui = CARD_UI.instantiate()
		card_ui.set_action(card)
		card_ui.on_selected = on_select_card_from_hand
		
		action_bar.add_child(card_ui)

func on_select_card_from_hand(card: ActionCard):
	print_debug(card)
	player_plays_card.emit(card)
	
func wait_for_card_played():
	var card = await player_plays_card
	for c in action_bar.get_children():
		action_bar.remove_child(c)
	return card
