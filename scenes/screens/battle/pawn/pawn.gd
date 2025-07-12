extends Node2D
class_name Pawn

var unit: Unit
var hp_value: int
signal clicked

@onready var hp_bar: ProgressBar = %HpBar
@onready var prepared_actions_bar: HBoxContainer = %PreparedActionsBar
@onready var unit_root: Node2D = %UnitRoot
@onready var hp_label: Label = %Label


func setup(unit: Unit, flip: bool = false):
	self.unit = unit
	self.hp_value = unit.hp
	var scene: UnitBaseUI = unit.instantiate_ui()
	scene.clicked.connect(clicked.emit.bind(self))
	unit.selected_actions_changed.connect(_on_selected_actions_changed)
	_on_selected_actions_changed(unit.selected_actions)
	unit_root.add_child(scene)
	if flip:
		scene.scale.x = -1
	hp_bar.max_value = unit.unit_data.max_hp
	hp_bar.value = unit.hp
	hp_label.text = "%s/%s" % [unit.hp, unit.unit_data.max_hp]


func update_status(hp_increnemnt: int):
	hp_value += hp_increnemnt
	hp_label.text = "%s/%s" % [clamp(hp_value, 0, unit.unit_data.max_hp), unit.unit_data.max_hp]

	var tween = create_tween()
	tween.tween_property(hp_bar, "value", hp_value, 0.4).set_ease(Tween.EASE_IN)

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
