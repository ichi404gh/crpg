class_name ActionPanel
extends Control

const ActionSlot = preload("uid://61idd8nro0ds")
const ACTION_SLOT = preload("uid://dhcty1gknjrlf")

@onready var close_button: Button = %CloseButton
@onready var actions_container: HFlowContainer = %ActionsContainer
@onready var slots_container: HBoxContainer = %SlotsContainer
@onready var action_points_label: Label = %ActionPointsLabel


var unit: Unit

signal closed

func _ready() -> void:
	close_button.pressed.connect(on_close)


func on_unit_action_changed(actions: Array[Action]):
	update_ap_label()
	for unit_action_index in actions.size():
		var action = actions[unit_action_index]

		if slots_container.get_child_count() <= unit_action_index:
			var slot = ACTION_SLOT.instantiate()
			slots_container.add_child(slot)
			slot.set_action(action)
			slot.cleared.connect(_on_slot_cleared.bind(unit_action_index))
		else:
			var slot: ActionSlot = slots_container.get_child(unit_action_index)
			slot.set_action(action)
	if slots_container.get_child_count() > actions.size():
		for idx in range(actions.size(), slots_container.get_child_count()):
			slots_container.get_child(idx).queue_free()

func on_close():
	closed.emit()

func _on_slot_cleared(index: int):
	unit.remove_actions(index)

func update_ap_label():
	action_points_label.text = "Action points: %s/%s" % [unit.combined_cost(), unit.action_points]

#func on_action_set(action: Action, idx: int):
	#unit.set_actions(idx, action)

func setup(unit: Unit):
	self.unit = unit
	unit.selected_actions_changed.connect(on_unit_action_changed)

	const ACTION_PANEL_ACTION = preload("res://scenes/screens/battle/panels/action_panel_action.tscn")

	on_unit_action_changed(unit.selected_actions)

	for c in actions_container.get_children():
		c.queue_free()

	for action_instance: ActionManager.ActionInstance in ActionManager.get_actions_selection_for_unit(unit):
		var apa = ACTION_PANEL_ACTION.instantiate()
		actions_container.add_child(apa)
		apa.setup(action_instance)
		apa.selected.connect(_on_action_selected)

	update_ap_label()


func _on_action_selected(action: Action):
	unit.add_action(action)
