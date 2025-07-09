extends Node
class_name BattleManager

signal stage_simulation_ready(SimulationData)

var is_running

var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []

var order: Array[Unit]
var stage: int = 0
var meta: Meta = Meta.new()


var damage_mananger: DamageManager = DamageManager.new(self)
var healing_manager: HealingManager = HealingManager.new(self)


func setup(player: Array[Unit], enemy: Array[Unit]) -> void:
	player_party = player
	enemy_party = enemy
	order = _get_turn_order()
	stage_simulation_ready.emit(SimulationData.new([], order))


func simulate_stage():
	var events: Array[AbstractBattleEevnt] = []
	var round_number: int = 0

	while round_number < 4:
		for unit in order:
			if !unit.alive:
				continue

			var unit_actions: Array[Action] = unit.selected_actions.filter(func (a): return a != null)

			if unit_actions.size() <= round_number:
				continue

			var action = unit_actions[round_number]
			var interaction_event: InteractionEvent = action.produce_event(unit)
			var action_events: Array[AbstractBattleEevnt] = []

			for effect: ActionEffect in action.effects:
				if not effect.have_targets(unit, self):
					continue
				var targets = effect.get_targets(unit, self)
				for target in targets:
					var event_effects = effect.apply(unit, target, self, action)
					for event_effect in event_effects:
						if event_effect is InteractionEvent.TargetEffect:
							interaction_event.target_effects.append(event_effect)
						else:
							action_events.append(event_effect)
			if not interaction_event.target_effects.is_empty():
				events.append(interaction_event)
			events.append_array(action_events)
		round_number += 1
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


func apply_status_effect(target: Unit, status_effect: StatusEffect):
	target.status_effects.append(status_effect)
	# TODO reapply effect
	# TODO handle effect
	# TODO clean effect

class SimulationData:
	var previous_stage_result: Array[AbstractBattleEevnt]
	var next_turn_order: Array[Unit]

	func _init(events: Array[AbstractBattleEevnt], order: Array[Unit]) -> void:
		previous_stage_result = events
		next_turn_order = order

class Meta:
	var hovered_unit: Unit
