extends Node2D

var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []

var selected_pawn: Pawn

var unit_to_pawn: Dictionary[Unit, Pawn] = {}
var unit_to_order_item: Dictionary[Unit, OrderPanelItem] = {}

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
		#MOUSEFOLK.instantiate(),
		#MOUSEFOLK.instantiate(),
		#MOUSEFOLK.instantiate(),
	] as Array[Unit]

	enemy_party = [
		#SKELETON.instantiate(),
		SKELETON_REAPER.instantiate(),
		BAT.instantiate(),
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
		pawn_ui.setup(unit, false, battle_manager)

	_width -= spacing


	_width = 0.0
	for idx in len(enemy_party.filter(Unit.is_alive)):
		var unit: Unit = enemy_party.filter(Unit.is_alive)[idx]
		var pawn_ui = PAWN.instantiate()
		pawn_ui.position = Vector2((idx*sprite_size + idx * spacing), 0)
		unit_to_pawn[unit] = pawn_ui


		_width += sprite_size + spacing
		enemy_party_node.add_child(pawn_ui)
		pawn_ui.setup(unit, true, battle_manager)

	_width -= spacing

func _on_unit_hover(unit: Unit, value: bool):
	if value:
		battle_manager.meta.hovered_unit = unit
	else:
		if battle_manager.meta.hovered_unit == unit:
			battle_manager.meta.hovered_unit = null

func _on_pawn_click(pwn: Pawn):
	selected_pawn = pwn
	actions_panel.setup(pwn.unit)
	actions_panel.show()

func _on_stage_result(data: BattleManager.SimulationData):
	actions_panel.hide()
	print(data.previous_stage_result)

	for event: AbstractBattleEvent in data.previous_stage_result:
		if event is InteractionEvent:
			if event.source:
				if event.source_fx:
					var scene: ActionFX = event.source_fx.instantiate()
					unit_to_pawn[event.source].get_node("%EffectRoot").add_child(scene)
					await scene.play_impact()
				match event.source_animation:
					InteractionEvent.AnimationKind.Attack:
						await event.source.unit_view.attack()
					InteractionEvent.AnimationKind.Interact:
						await event.source.unit_view.interact()
			for target_effect: InteractionEvent.TargetEffect in event.target_effects:
				match target_effect.animation:
					InteractionEvent.AnimationKind.Hurt:
						target_effect.target.unit_view.hurt()
				if target_effect.hp_change < 0:
					const DAMAGE_INDICATOR = preload("uid://bbkvpkjbemqiw")
					var scene = DAMAGE_INDICATOR.instantiate()
					unit_to_pawn[target_effect.target].get_node("%EffectRoot").add_child(scene)
					scene.setup(-target_effect.hp_change)


				unit_to_pawn[target_effect.target].update_status(target_effect.hp_change, null)
				if target_effect.fx:
					var scene: ActionFX = target_effect.fx.instantiate()
					unit_to_pawn[target_effect.target].get_node("%EffectRoot").add_child(scene)
					await scene.play_impact()
			if event.source:
				await event.source.unit_view.finish_animations()
#

		elif event is OffInteractionDamageEvent:
			if event.hurt:
				await event.target.unit_view.hurt()

			unit_to_pawn[event.target].update_status(event.hp_change, null)
		elif event is StatusEffectsUpdatedEvent:
			unit_to_pawn[event.target].update_status(0, event.effects)
		elif event is UnitDeadEvent:
			# TODO: disable ui for dead pawn
			event.who.unit_view.die()
			order_panel.remove_child(unit_to_order_item[event.who])


	print("battle stopped")
	_update_order_panel()
	set_ai_actions()

func set_ai_actions():
	for u in player_party + enemy_party:
		if u.ai_controlled:
			u.selected_actions = ActionManager.select_action_for_ai_unit(u)
			u.selected_actions_changed.emit(u.selected_actions)

func _on_panel_closed():
	actions_panel.hide()
	selected_pawn = null

func _update_order_panel():
	# clean unwanted
	for item in order_panel.get_children():
		if item not in unit_to_order_item.values():
			order_panel.remove_child(item)

	# add new items
	for unit in battle_manager.order:
		if not unit_to_order_item.has(unit):
			const ORDER_PANEL_ITEM = preload("res://scenes/screens/battle/panels/order_panel_item.tscn")
			var item = ORDER_PANEL_ITEM.instantiate()
			order_panel.add_child(item)
			item.setup(unit, battle_manager)
			unit_to_order_item.set(unit, item)

	# rorder
	for i in battle_manager.order.size():
		order_panel.move_child(unit_to_order_item[battle_manager.order[i]], i)



func _on_run_battle_pressed():
	battle_manager.simulate_stage()
