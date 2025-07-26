class_name Unit


@export var hp: int
@export var unit_name: String
@export var alive: bool = true
@export var unit_data: UnitData
@export var ai_controlled: bool

@export var action_points: int = 3

var status_effects: Array[Status]

var unit_view: UnitBaseUI

signal selected_actions_changed(actions: Array[Action])

var selected_actions: Array[Action] = []
var cooldowns: Dictionary[String, int] = {}

func remove_actions(index: int):
	selected_actions.remove_at(index)
	selected_actions_changed.emit(selected_actions)

func add_action(action: Action):
	if combined_cost() + action.cost > action_points:
		return
	if cooldowns.has(action.key):
		return
	if action.cooldown > 0 and have_plannet_action_with_key(action.key):
		return
	selected_actions.append(action)
	selected_actions_changed.emit(selected_actions)

func have_plannet_action_with_key(key: String):
	for a in selected_actions:
		if a.key == key:
			return true
	return false

func clear_cooling_down_actions():
	var old_size = selected_actions.size()
	selected_actions = selected_actions.filter(func(a: Action): return not cooldowns.has(a.key))
	if selected_actions.size() != old_size:
		selected_actions_changed.emit(selected_actions)


func combined_cost():
	return selected_actions.map(func(a: Action): return a.cost).reduce(func(a,b): return a+b, 0)

func tick_cooldowns():
	for key in cooldowns:
		cooldowns[key] -= 1
		if cooldowns[key] <= 0:
			cooldowns.erase(key)


func _to_string() -> String:
	return "%s, (%s)" % [unit_name, hp]

static func is_alive(unit: Unit) -> bool:
	return unit.alive

func instantiate_ui():
	if not unit_data:
		return

	unit_view = unit_data.unit_ui.instantiate() as UnitBaseUI
	return unit_view

func have_status(status: Status) -> bool:
	return find_applied_status(status) != null

func find_applied_status(status: Status) -> Status:
	for unit_status in self.status_effects:
		if unit_status.title == status.title: # FIXME
			return unit_status
	return null
