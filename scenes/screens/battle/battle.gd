extends Node2D

var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []

var selected_pawn: Pawn
var selected_order: Order

var unit_to_pawn: Dictionary[Unit, Pawn] = {}
var unit_to_order_item: Dictionary[Unit, OrderPanelItem] = {}

@onready var battle_manager: BattleManager = %BattleManager
@onready var actions_panel: ActionPanel = %ActionsPanel
@onready var turn_order_panel: HBoxContainer = %TurnOrderPanel

@onready var start_battle_button: Button = %StartRoundButton


@onready var player_party_node: Node2D = %PlayerParty
@onready var enemy_party_node: Node2D = %EnemyParty
@onready var hand: Control = %Hand

@export var spacing: float = 30.0
@export var sprite_size: float = 100.0

const ORDER_CARD = preload("uid://ddppw4m4cqbc8")
const OrderCard = preload("uid://bvv5fkcgk0k53")

var hand_y: float

var buttons_enabled: bool = true

func _ready() -> void:
	TranslationServer.set_locale("en-us")
	connect_signals()
	setup_ui()

	setup_stub()
	arrange_slots()

func setup_ui():
	hand_y = hand.position.y

func setup_stub():
	const MOUSEFOLK = preload("uid://bj5wsdwq6hy7e")
	const SKELETON = preload("uid://nqkobm5ii7rg")
	const SKELETON_REAPER = preload("uid://d00w56ml886iu")
	const BAT = preload("uid://hwd0lxpta2ko")


	player_party = [
		MOUSEFOLK.instantiate(),
		MOUSEFOLK.instantiate(),
		MOUSEFOLK.instantiate(),
		#MOUSEFOLK.instantiate(),
	] as Array[Unit]

	enemy_party = [
		#SKELETON.instantiate(),
		SKELETON_REAPER.instantiate(),
		BAT.instantiate(),
		BAT.instantiate(),
		#MOUSEFOLK.instantiate(),
	] as Array[Unit]


	battle_manager.setup(player_party, enemy_party)
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

func arrange_hand(_orders: Array[Order]):
	var orders = _orders


	const width := 300.0
	const k := 3
	const r := deg_to_rad(5)



	for child in hand.get_children():
		if child != start_battle_button:
			child.queue_free()

	@warning_ignore("integer_division")
	var center = (orders.size() - 1) / 2

	for idx in orders.size():
		var order = orders[idx]
		var child: OrderCard = ORDER_CARD.instantiate()
		hand.add_child(child)
		child.setup(order)
		child.clicked.connect(_on_order_selected)
		child.position.x += (width/orders.size()) * idx - width / 2.0
		child.position.y += k * (idx - center)**2
		child.rotation += r * (idx - center)


func _on_order_selected(order: Order):
	selected_order = order
	start_battle_button.disabled = order == null
	battle_manager.orders_manager.active_order = order

	for child: OrderCard in hand.get_children():
		child.set_selected(child.order == order)


func _on_unit_hover(unit: Unit, value: bool):
	if value:
		battle_manager.meta.hovered_unit = unit
	else:
		if battle_manager.meta.hovered_unit == unit:
			battle_manager.meta.hovered_unit = null

func _on_pawn_click(pwn: Pawn):
	if !buttons_enabled:
		return
	selected_pawn = pwn
	actions_panel.setup(pwn.unit, battle_manager)
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
			unit_to_pawn[event.who].die()
			turn_order_panel.remove_child(unit_to_order_item[event.who])


	print("battle stopped")
	_update_order_panel()
	set_ai_actions()
	arrange_hand(data.unit_orders)
	set_buttons_enabled(true)
	_on_order_selected(null)

func set_ai_actions():
	for u in player_party + enemy_party:
		if not u.alive:
			continue
		if u.auto_selects_actions:
			ActionManager.auto_select_actions(u, battle_manager)

func _on_panel_closed():
	actions_panel.hide()
	selected_pawn = null

func _update_order_panel():
	# clean unwanted
	for item in turn_order_panel.get_children():
		if item not in unit_to_order_item.values():
			turn_order_panel.remove_child(item)

	# add new items
	for unit in battle_manager.turn_order:
		if not unit_to_order_item.has(unit):
			const ORDER_PANEL_ITEM = preload("res://scenes/screens/battle/panels/order_panel_item.tscn")
			var item = ORDER_PANEL_ITEM.instantiate()
			turn_order_panel.add_child(item)
			item.setup(unit, battle_manager)
			unit_to_order_item.set(unit, item)

	# reorder
	for i in battle_manager.turn_order.size():
		turn_order_panel.move_child(unit_to_order_item[battle_manager.turn_order[i]], i)



func _on_run_battle_pressed():
	hide_orders()
	set_buttons_enabled(false)
	battle_manager.simulate_stage()

func set_buttons_enabled(value: bool):
	if value:
		show_orders()
	else:
		hide_orders()

	start_battle_button.disabled = true
	buttons_enabled = value

func hide_orders():
	var t = create_tween()
	t.tween_property(hand, "position:y", hand.position.y + 500, 0.5).set_trans(Tween.TRANS_CIRC)

func show_orders():
	var t = create_tween()
	t.tween_property(hand, "position:y", hand_y, 0.5).set_trans(Tween.TRANS_CIRC)
