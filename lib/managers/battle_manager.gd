extends Node
class_name BattleManager

signal stage_simulation_ready(SimulationData)

var is_running

var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []

var order: Array[Unit]
var stage: int = 0
var meta: Meta = Meta.new()

var modificator_registry: ModificatorRegistry = ModificatorRegistry.new()


var damage_mananger: DamageManager = DamageManager.new(self)
var healing_manager: HealingManager = HealingManager.new(self)
var status_effect_manager: StatusEffectManager = StatusEffectManager.new(self)
var reaction_manager: ReactionManager = ReactionManager.new(self)

func setup(player: Array[Unit], enemy: Array[Unit]) -> void:
	player_party = player
	enemy_party = enemy
	order = _get_turn_order()
	stage_simulation_ready.emit(SimulationData.new([], order))

func tick_before_round_buffs(round_number: int, unit: Unit) -> Array[AbstractBattleEvent]:
	var events = [] as Array[AbstractBattleEvent]
	if round_number == 0:
		for status in unit.status_effects:
			for buff in status.buffs:
				if buff.ticks_before_round:
					events.append_array(buff.tick(unit, self))
	return events

func tick_after_round_buffs(unit: Unit) -> Array[AbstractBattleEvent]:
	var events: Array[AbstractBattleEvent] = []
	for status in unit.status_effects:
		for buff in status.buffs:
			if buff.ticks_after_round:
				var tick_events = buff.tick(unit, self)
				events.append_array(tick_events)
	return events

func simulate_stage():
	var events: Array[AbstractBattleEvent] = []

	for round_number in 4:
		for unit in order:
			if not unit.alive:
				continue

			events.append_array(tick_before_round_buffs(round_number, unit))
			var unit_actions: Array[Action] = unit.selected_actions.filter(func (a): return a != null)

			if unit_actions.size() <= round_number:
				continue

			var action = unit_actions[round_number]
			events.append_array(action.apply(unit, self))


	for unit in order:
		if not unit.alive:
			continue

		events.append_array(tick_after_round_buffs(unit))
		events.append_array(status_effect_manager.expire_statuses(unit))

	order = _get_turn_order()
	stage_simulation_ready.emit(SimulationData.new(events, order))

func _get_own_alive_party(unit: Unit) -> Array[Unit]:
	if unit not in player_party:
		return enemy_party.filter(Unit.is_alive)
	return player_party.filter(Unit.is_alive)

func _get_opposite_alive_party(unit: Unit) -> Array[Unit]:
	if unit in player_party:
		return enemy_party.filter(Unit.is_alive)
	return player_party.filter(Unit.is_alive)

func _get_turn_order() -> Array[Unit]:
	var _order: Array[Unit] = []
	_order.append_array(player_party.filter(func (u: Unit): return u.alive))
	_order.append_array(enemy_party.filter(func (u: Unit): return u.alive))
	_order.shuffle()
	return _order


class SimulationData:
	var previous_stage_result: Array[AbstractBattleEvent]
	var next_turn_order: Array[Unit]

	func _init(events: Array[AbstractBattleEvent], order: Array[Unit]) -> void:
		previous_stage_result = events
		next_turn_order = order

class Meta:
	signal hovered_unit_changed(unit: Unit)
	var hovered_unit: Unit:
		set(value):
			if hovered_unit != value:
				hovered_unit_changed.emit(value)
			hovered_unit = value
