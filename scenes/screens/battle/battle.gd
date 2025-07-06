
extends Node2D

var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []

var selected_pawn: Pawn

var unit_to_pawn: Dictionary[Unit, Pawn] = {}

@onready var battle_manager: BattleManager = $BattleManager
@onready var actions_panel: ActionPanel = $CanvasLayer/ActionsPanel
@onready var order_panel: HBoxContainer = $CanvasLayer/OrderPanel
@onready var start_battle_button: Button = $CanvasLayer/Button


func _ready() -> void:
	connect_signals()

	setup_stub()


func setup_stub():
	const SWORD_SLASH = preload("uid://cf5ul8llmqy0c")
	player_party = [
		Unit.new(),
		Unit.new(),
	]

	enemy_party = [
		Unit.new(),
		Unit.new(),
		Unit.new(),
	]

	battle_manager.setup(player_party, enemy_party)
	for e in enemy_party:
		e.set_actions(0, SWORD_SLASH)

func connect_signals():
	battle_manager.stage_simulation_ready.connect(_on_stage_result)
	actions_panel.closed.connect(_on_panel_closed)
	start_battle_button.pressed.connect(_on_run_battle_pressed)


func arrange_slots():
	const spacing = 30.0
	const sprite_size = 32
	const PAWN = preload("res://scenes/screens/battle/pawn/pawn.tscn")

	for u in $PlayerParty.get_children():
		u.queue_free()
	for u in $EnemyParty.get_children():
		u.queue_free()

	var _width = 0.0
	for idx in len(player_party.filter(Unit.is_alive)):
		var unit: Unit = player_party.filter(Unit.is_alive)[idx]
		var pawn_ui = PAWN.instantiate()
		pawn_ui.position = Vector2(-(idx*sprite_size + idx * spacing), 0)
		pawn_ui.setup(unit, battle_manager)
		unit_to_pawn[unit] = pawn_ui

		pawn_ui.clicked.connect(_on_pawn_click)

		_width += sprite_size + spacing
		$PlayerParty.add_child(pawn_ui)
	_width -= spacing


	_width = 0.0
	for idx in len(enemy_party.filter(Unit.is_alive)):
		var unit: Unit = enemy_party.filter(Unit.is_alive)[idx]
		var pawn_ui = PAWN.instantiate()
		pawn_ui.position = Vector2(-(idx*sprite_size + idx * spacing), 0)
		pawn_ui.setup(unit, battle_manager)
		unit_to_pawn[unit] = pawn_ui

		pawn_ui.flip()

		_width += sprite_size + spacing
		$EnemyParty.add_child(pawn_ui)
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
			await unit_to_pawn[event.source].attack()
			await unit_to_pawn[event.target].hurt()
			await unit_to_pawn[event.source].finish_animations()
			await unit_to_pawn[event.target].finish_animations()
		elif event is CombatEvent.Dies:
			pass

	_update_order_panel()
	arrange_slots()

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
