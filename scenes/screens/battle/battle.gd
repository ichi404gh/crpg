extends Node2D

var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []

var selected_pawn: Pawn

var unit_to_pawn: Dictionary[Unit, Pawn] = {}

@onready var battle_manager: BattleManager = %BattleManager
@onready var actions_panel: ActionPanel = %ActionsPanel
@onready var order_panel: HBoxContainer = %OrderPanel
@onready var start_battle_button: Button = %Button

@onready var player_party_node: Node2D = %PlayerParty
@onready var enemy_party_node: Node2D = %EnemyParty

@export var spacing = 30.0
@export var sprite_size = 100

func _ready() -> void:
	connect_signals()
	setup_stub()
	arrange_slots()


func setup_stub():
	const MOUSEFOLK = preload("uid://bj5wsdwq6hy7e")
	const SKELETON = preload("uid://nqkobm5ii7rg")
	const SKELETON_REAPER = preload("uid://d00w56ml886iu")
	const BAT = preload("uid://hwd0lxpta2ko")

	player_party = [
		MOUSEFOLK.instantiate(),
		#SKELETON.instantiate(),
		MOUSEFOLK.instantiate(),
		#MOUSEFOLK.instantiate(),
	] as Array[Unit]

	enemy_party = [
		SKELETON.instantiate(),
		SKELETON_REAPER.instantiate(),
		BAT.instantiate(),
		#MOUSEFOLK.instantiate(),
	] as Array[Unit]


	for u in enemy_party:
		u.ai_controlled = true

	battle_manager.setup(player_party, enemy_party)
	#for e in enemy_party:
		#e.set_actions(0, SWORD_SLASH)
	set_ai_actions()


func connect_signals():
	battle_manager.stage_simulation_ready.connect(_on_stage_result)
	actions_panel.closed.connect(_on_panel_closed)
	start_battle_button.pressed.connect(_on_run_battle_pressed)


func arrange_slots():

	const PAWN = preload("uid://dmwqt8pe1nwg5")
	for u in player_party_node.get_children():
		u.queue_free()
	for u in enemy_party_node.get_children():
		u.queue_free()

	var _width = 0.0
	for idx in len(player_party.filter(Unit.is_alive)):
		var unit: Unit = player_party.filter(Unit.is_alive)[idx]
		var pawn_ui = PAWN.instantiate()
		pawn_ui.position = Vector2(-(idx*sprite_size + idx * spacing), 0)
		unit_to_pawn[unit] = pawn_ui

		pawn_ui.clicked.connect(_on_pawn_click)

		_width += sprite_size + spacing
		player_party_node.add_child(pawn_ui)
		pawn_ui.setup(unit)

	_width -= spacing


	_width = 0.0
	for idx in len(enemy_party.filter(Unit.is_alive)):
		var unit: Unit = enemy_party.filter(Unit.is_alive)[idx]
		var pawn_ui = PAWN.instantiate()
		pawn_ui.position = Vector2((idx*sprite_size + idx * spacing), 0)
		unit_to_pawn[unit] = pawn_ui


		_width += sprite_size + spacing
		enemy_party_node.add_child(pawn_ui)
		pawn_ui.setup(unit, true)

	_width -= spacing


func _on_pawn_click(pwn: Pawn):
	selected_pawn = pwn
	actions_panel.setup(pwn.unit)
	actions_panel.show()

func _on_stage_result(data: BattleManager.SimulationData):
	actions_panel.hide()
	print(data.previous_stage_result)

	for event: CombatEvent in data.previous_stage_result:
		if event is CombatEvent.Attacks:
			await event.source.unit_view.attack()
			unit_to_pawn[event.target].update_status(-event.damage)
			if event.effect_scene:
				var scene: ActionFX = event.effect_scene.instantiate()
				unit_to_pawn[event.target].get_node("%EffectRoot").add_child(scene)
				scene.play_impact()
			await event.target.unit_view.hurt()
			await event.source.unit_view.finish_animations()
			await event.target.unit_view.finish_animations()
		elif event is CombatEvent.Dies:
			await event.who.unit_view.die()
		elif event is CombatEvent.Interact:
			await event.target.unit_view.interact()
			unit_to_pawn[event.target].update_status(-event.damage)
			if event.effect_scene:
				var scene: ActionFX = event.effect_scene.instantiate()
				unit_to_pawn[event.target].get_node("%EffectRoot").add_child(scene)
				scene.play_impact()

	_update_order_panel()
	set_ai_actions()
	#arrange_slots()

func set_ai_actions():
	for u in player_party:
		if u.ai_controlled:
			u.selected_actions = ActionManager.select_action_for_ai_unit(u)
			u.selected_actions_changed.emit(u.selected_actions)

	for u in enemy_party:
		if u.ai_controlled:
			u.selected_actions = ActionManager.select_action_for_ai_unit(u)
			u.selected_actions_changed.emit(u.selected_actions)

func _on_panel_closed():
	actions_panel.hide()
	selected_pawn = null

func _update_order_panel():
	for c in order_panel.get_children():
		c.queue_free()

	for unit in battle_manager.order:
		const ORDER_PANEL_ITEM = preload("res://scenes/screens/battle/panels/order_panel_item.tscn")
		var item = ORDER_PANEL_ITEM.instantiate()
		order_panel.add_child(item)
		item.setup(unit, battle_manager)

func _on_run_battle_pressed():
	battle_manager.simulate_stage()
