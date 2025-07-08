extends Node2D
class_name Pawn

var unit: Unit

signal clicked

@onready var hp_bar: ProgressBar = $HpBar
@onready var prepared_actions_bar: HBoxContainer = $PreparedActionsBar
@onready var unit_root: Node2D = $UnitRoot


func setup(unit: Unit, flip: bool = false):
	self.unit = unit
	var scene: UnitBaseUI = unit.instantiate_ui()
	scene.clicked.connect(clicked.emit.bind(self))
	unit.selected_actions_changed.connect(_on_selected_actions_changed)
	_on_selected_actions_changed(unit.selected_actions)
	unit_root.add_child(scene)
	if flip:
		scene.scale.x = -1
	hp_bar.max_value = unit.unit_data.max_hp
	hp_bar.value = unit.hp

func update_status(hp_increnemnt: int):
	hp_bar.value += hp_increnemnt

func _on_selected_actions_changed(actions: Array[Action]):
	const PREPARED_ACTION_UI = preload("uid://cjad02w8v2per")
	for c in prepared_actions_bar.get_children():
		c.queue_free()
	for action in actions:
		if action == null:
			continue

		var action_ui: PreparedActionUI = PREPARED_ACTION_UI.instantiate()
		prepared_actions_bar.add_child(action_ui)
		action_ui.setup(action)
