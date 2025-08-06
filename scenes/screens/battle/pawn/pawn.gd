extends Node2D
class_name Pawn

var unit: Unit
var hp_value: int
var battle_manager: BattleManager

signal clicked

const HpEsBar = preload("uid://bxlm577yi2lcd")
@onready var hp_es_bar: HpEsBar = $TooltipContext/HpEsBar
@onready var prepared_actions_bar: HBoxContainer = %PreparedActionsBar
@onready var status_bar: HBoxContainer = %StatusBar
@onready var unit_root: Node2D = %UnitRoot
@onready var damage_numbers_root: Node2D = %DamageNumbersRoot

const DMG_COLOR: Color = Color(0.834, 0.29, 0.123, 1.0)
const DMG_OUTLINE_COLOR: Color = Color(0.514, 0.159, 0.046, 1.0)
const HEAL_COLOR: Color = Color(0.0, 0.653, 0.372, 1.0)
const HEAL_OUTLINE_COLOR: Color = Color(0.0, 0.0, 0.0, 1.0)

const HOVER_COLOR: Color = Color(1, 0.94313726, 0.8, 1)


func setup(unit: Unit, flip: bool, battle_manager: BattleManager):
	self.battle_manager = battle_manager
	battle_manager.meta.hovered_unit_changed.connect(on_hovered_unit_changed)

	self.unit = unit
	self.hp_value = unit.hp
	var scene: UnitBaseUI = unit.instantiate_ui()
	scene.clicked.connect(clicked.emit.bind(self))
	scene.hovered.connect(on_unit_hovered)
	unit.selected_actions_changed.connect(_on_selected_actions_changed)
	_on_selected_actions_changed(unit.selected_actions)
	unit_root.add_child(scene)
	if flip:
		scene.scale.x = -1

	hp_es_bar.hp_max = unit.total_max_hp
	hp_es_bar.hp = unit.hp
	hp_es_bar.es_max = unit.total_max_es
	hp_es_bar.es = unit.es
	update_status(0, 0, unit.status_effects)
func die():
	hp_es_bar.hide()
	status_bar.hide()
	prepared_actions_bar.hide()

func on_hovered_unit_changed(unit: Unit):
	const OUTLINE = preload("uid://rllvcdkeolch")
	var scene = unit_root.get_child(0) as Node2D

	if unit == self.unit:
		var scene_material = ShaderMaterial.new()
		scene_material.shader = OUTLINE
		scene_material.set_shader_parameter("clr", Color.WHITE)
		scene_material.set_shader_parameter("type", 2)
		scene_material.set_shader_parameter("thickness", 3.0)
		scene.material = scene_material
	else:
		scene.material = null

func on_unit_hovered(value: bool):
	if value:
		self.battle_manager.meta.hovered_unit = unit
	else:
		if self.battle_manager.meta.hovered_unit == unit:
			self.battle_manager.meta.hovered_unit = null


func update_status(hp_increnemnt: int, es_increment: int, statuses):
	hp_es_bar.update_ui()
	hp_es_bar.hp += hp_increnemnt
	hp_es_bar.es += es_increment

	on_statuses_changed(statuses)


	if hp_increnemnt != 0:
		const FLOATING_NUMBERS = preload("uid://dsy2hrnd3i4np")
		var number = FLOATING_NUMBERS.instantiate()
		damage_numbers_root.add_child(number)
		number.position = Vector2(randf_range(-20, 20), randf_range(-20, 20))
		if hp_increnemnt > 0:
			number.label_settings.font_color = HEAL_COLOR
			number.label_settings.outline_color = HEAL_OUTLINE_COLOR
		else:
			number.label_settings.font_color = DMG_COLOR
			number.label_settings.outline_color = DMG_OUTLINE_COLOR

		number.text = str(abs(hp_increnemnt))
		number.modulate.a = 1
		var tween = create_tween()

		tween.parallel().tween_property(number, "position:y", -50, 0.9)
		tween.parallel().tween_property(number, "modulate:a", 0, 0.9)
		await tween.finished
		number.position.y = 0
		number.modulate.a = 0

func on_statuses_changed(statuses):
	if statuses == null:
		return
	const ACTIVE_STATUS_UI = preload("uid://bnp7660y8su5h")

	for c in status_bar.get_children():
		c.queue_free()

	for status in statuses as Array[Status]:
		var status_ui: ActiveStatusUI = ACTIVE_STATUS_UI.instantiate()
		status_bar.add_child(status_ui)
		status_ui.setup(status)

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
