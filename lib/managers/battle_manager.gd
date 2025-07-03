extends Node
class_name BattleManager

signal stage_simulation_ready(SimulationData)

var is_running

var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []

var order: Array[Unit]
var stage: int = 0
var meta: Meta = Meta.new()

func setup(player: Array[Unit], enemy: Array[Unit]) -> void:
	player_party = player
	enemy_party = enemy
	order = _get_turn_order()
	stage_simulation_ready.emit(SimulationData.new([], order))


func simulate_stage():
	var events: Array[CombatEvent] = []
	var round_number: int = 0

	while round_number < 4:
		for unit in order:
			if !unit.alive:
				continue

			var plan: Array[Action] = unit.selected_actions.filter(func (a): return a != null)
			
			if plan.size() <= round_number:
				continue

			var action = plan[round_number]
			for effect in action.effects:
				if effect is DamageEffect:
					var target = _get_opposite_alive_party(unit).pick_random()
					if  not target:
						continue
					effect.apply(unit, target, self)
					events.append(CombatEvent.attack(unit, target, effect.amount))
					if !target.alive:
						events.append(CombatEvent.dies(target))
				if effect is HealEffect:
					var target = _get_own_alive_party(unit).pick_random()
					effect.apply(unit, target, self)

				else:
					push_error("unknown action type")
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
	
	
func apply_damage(target: Unit, amount: int):
	target.hp -= amount
	if target.hp <= 0:
		target.alive = false

func apply_heal(target: Unit, amount: int):
	target.hp += amount

class SimulationData:
	var previous_stage_result: Array[CombatEvent]
	var next_turn_order: Array[Unit]
	
	func _init(events: Array[CombatEvent], order: Array[Unit]) -> void:
		previous_stage_result = events
		next_turn_order = order

class Meta:
	var hovered_unit: Unit
