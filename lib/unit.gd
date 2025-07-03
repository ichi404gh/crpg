class_name Unit

@export var hp: int = 20
@export var unit_name: String = "Slime"
@export var alive: bool = true
@export var effects: Dictionary[StatusEffect, float] = {}

signal selected_actions_changed(actions: Array[Action])

var selected_actions: Array[Action] = [null, null, null, null]

func set_actions(index: int, action: Action):
	selected_actions[index] = action
	selected_actions_changed.emit(selected_actions)

func _to_string() -> String:
	return "%s, (%s)" % [unit_name, hp]

static func is_alive(unit: Unit) -> bool:
	return unit.alive
