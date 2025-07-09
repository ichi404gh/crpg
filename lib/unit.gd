class_name Unit


@export var hp: int
@export var unit_name: String
@export var alive: bool = true
@export var unit_data: UnitData
@export var ai_controlled: bool
@export var status_effects: Array[StatusEffect]

var unit_view: UnitBaseUI

signal selected_actions_changed(actions: Array[Action])

var selected_actions: Array[Action] = [null, null, null, null]

func set_actions(index: int, action: Action):
	selected_actions[index] = action
	selected_actions_changed.emit(selected_actions)

func _to_string() -> String:
	return "%s, (%s)" % [unit_name, hp]

static func is_alive(unit: Unit) -> bool:
	return unit.alive

func instantiate_ui():
	if not unit_data:
		return

	unit_view = unit_data.unit_ui.instantiate() as UnitBaseUI
	return unit_view
