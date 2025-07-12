extends Node2D
class_name Pawn

var unit: Unit
var hp_value: int
signal clicked

@onready var hp_bar: ProgressBar = %HpBar
@onready var prepared_actions_bar: HBoxContainer = %PreparedActionsBar
@onready var unit_root: Node2D = %UnitRoot
@onready var hp_label: Label = %Label
@onready var damage_numbers_root: Node2D = %DamageNumbersRoot

const DMG_COLOR: Color = Color.FIREBRICK
const HEAL_COLOR: Color = Color.WEB_GREEN

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

	const FLOATING_NUMBERS = preload("uid://dsy2hrnd3i4np")
	var number = FLOATING_NUMBERS.instantiate()
	damage_numbers_root.add_child(number)
	if hp_increnemnt > 0:
		number.label_settings.font_color = HEAL_COLOR
	else:
		number.label_settings.font_color = DMG_COLOR
	number.text = str(abs(hp_increnemnt))
#
	number.modulate.a = 1
	tween.parallel().tween_property(number, "position:y", -50, 0.9)
	tween.parallel().tween_property(number, "modulate:a", 0, 0.9)
	await tween.finished
	number.position.y = 0
	number.modulate.a = 0

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
