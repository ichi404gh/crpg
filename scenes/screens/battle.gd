extends Node2D

@onready var battle_manager: BattleManager = $BattleManager
@onready var deck_manager: DeckManager = $DeckManager
@onready var action_bar: HBoxContainer = $CanvasLayer/Control/ActionBar
@onready var flat_target_list: VBoxContainer = $CanvasLayer/Control/FlatTargetList

const LIGHT_ATTACK = preload("res://data/action_cards/light_attack.tres")
const HEAVY_ATTACK = preload("res://data/action_cards/heavy_attack.tres")
const VERY_FAST_ATTACK = preload("res://data/action_cards/very_fast_attack.tres")

signal player_plays_card(card: ActionCard)

var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []
var state : State = State.Idle

var card_player: Unit
var player_hand: Array[ActionCard]
var player_card: ActionCard

func _ready():	
	var hero = Unit.new()
	hero.unit_name = "Hero"
	hero.hp = 20
	
	var enemy = Unit.new()
	enemy.unit_name = "Enemy1"
	enemy.hp = 20
	
	var enemy2 = Unit.new()
	enemy2.unit_name = "Enemy2"
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
		card_player = card.source
		player_hand = hand
		transit_state(State.SelectCard)
	else:
		battle_manager.play_card(card.source, player_party[randi_range(0, player_party.size() - 1)], hand[randi_range(0, hand.size() - 1)])

func initiate_select_target():
	for c in flat_target_list.get_children():
		c.queue_free()
		
	var target_result: BattleManager.TargetQueryResult = battle_manager.get_valid_targets(player_card, card_player)
	if !target_result.have_targets:
		transit_state(State.SelectCard)
		print("card does not have valid targets")
		return
		
	const TARGET_UI = preload("res://scenes/ui/target_ui.tscn")
	if target_result.targets.size() == 0:
		var target_ui = TARGET_UI.instantiate()
		target_ui.set_unit(card_player)
		target_ui.on_selected = on_select_target

		flat_target_list.add_child(target_ui)
	
	for target in target_result.targets:
		var target_ui = TARGET_UI.instantiate()
		target_ui.set_unit(target)
		target_ui.on_selected = on_select_target
		flat_target_list.add_child(target_ui)
	
	
func on_select_target(target: Unit):
	transit_state(State.Idle)
	battle_manager.play_card(card_player, target, player_card)
	battle_manager.resume()
	

func show_hand(hand: Array[ActionCard]):
	for c in action_bar.get_children():
		c.queue_free()

	const CARD_UI = preload("res://scenes/ui/card_ui.tscn")
	for card in hand:
		var card_ui = CARD_UI.instantiate()
		card_ui.set_action(card)
		card_ui.on_selected = on_select_card
		action_bar.add_child(card_ui)

func on_select_card(card: ActionCard):
	player_card = card
	transit_state(State.SelectTarget)
		
	
enum State { Idle, SelectCard, SelectTarget }

func transit_state(to: State):
	match to:
		State.Idle:
			state = to
			for c in action_bar.get_children():
				c.queue_free()
			for c in flat_target_list.get_children():
				c.queue_free()
			flat_target_list.offset_left = 0
			action_bar.offset_top = 0

		State.SelectCard:
			state = to
			battle_manager.pause()
			var tween = create_tween()

			show_hand(player_hand)
			tween.tween_property(action_bar, "offset_top" , -50, 0.4)\
				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		State.SelectTarget:
			initiate_select_target()
			var tween = create_tween()
			tween.tween_property(flat_target_list, "offset_left", -200, 0.4)\
				.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			
			assert(state != State.Idle, "Illegal state change from %s to %s" % [state, to])
			state = to
