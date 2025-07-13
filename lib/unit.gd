class_name Unit


@export var hp: int
@export var unit_name: String
@export var alive: bool = true
@export var unit_data: UnitData
@export var ai_controlled: bool

var status_effects: Array[Unit.AppliedStatusEffect]

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

func have_status(status_effect: StatusEffect) -> bool:
	return self.status_effects.any(func (asf: AppliedStatusEffect): return asf.status_effect == status_effect)

func find_applied_status(status_effect: StatusEffect) -> AppliedStatusEffect:
	for applied_status in self.status_effects:
		if applied_status.status_effect == status_effect:
			return applied_status
	return null


class AppliedStatusEffect:
	var status_effect: StatusEffect
	var duration: int
	
	func _to_string() -> String:
		return "%s, %s" % [status_effect.title, duration]
	
	func _init(status_effect: StatusEffect, duration: int):
		self.status_effect = status_effect
		self.duration = duration
