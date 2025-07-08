class_name ActionPanel
extends Control

@onready var close_button: Button = %CloseButton
@onready var actions_container: HFlowContainer = %ActionsContainer
@onready var slots_container: HBoxContainer = %SlotsContainer

var unit: Unit

signal closed

func _ready() -> void:
	close_button.pressed.connect(on_close)
	for idx in slots_container.get_children().size():
		(slots_container.get_child(idx) as ActionSlot).action_set.connect(on_action_set.bind(idx))

func on_close():
	closed.emit()

func on_action_set(action: Action, idx: int):
	unit.set_actions(idx, action)

func setup(_unit: Unit):
	unit = _unit

	const ACTION_PANEL_ACTION = preload("res://scenes/screens/battle/panels/action_panel_action.tscn")

	for c in slots_container.get_children():
		c.clear_slot()

	for action_idx in unit.selected_actions.size():
		slots_container.get_child(action_idx).set_action(unit.selected_actions[action_idx])

	for c in actions_container.get_children():
		c.queue_free()

	for a in ActionManager.get_actions_selection_for_unit(unit):
		var apa = ACTION_PANEL_ACTION.instantiate()
		apa.setup(a)
		actions_container.add_child(apa)
		apa.selected.connect(_on_action_selected)
		apa.dragging.connect(_hilight_slots)

func _on_action_selected(action: Action):
	var free_idx := 0
	for action_idx in unit.selected_actions.size():
		free_idx = action_idx
		if unit.selected_actions[action_idx] == null:
			break;

	var slot: ActionSlot = slots_container.get_child(free_idx) as ActionSlot
	slot.set_action(action)

func _hilight_slots():
	for slot: ActionSlot in slots_container.get_children():
		slot.hilight = true
