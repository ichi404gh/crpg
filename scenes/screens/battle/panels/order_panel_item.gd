class_name OrderPanelItem
extends Control

@export var ally_color: Color = Color("254f40")
@export var enemy_color: Color = Color("863840")
@export var hover_color: Color = Color("a56533")
@onready var panel: Panel = $Panel
@onready var color_rect: ColorRect = $Panel/ColorRect
@onready var name_label: Label = $Panel/VBoxContainer/Label
@onready var portrait: TextureRect = $Panel/VBoxContainer/TextureRect

var is_ally: bool = true
var unit: Unit
var battle_manager: BattleManager

func setup(unit: Unit, battle_manager: BattleManager):
	self.unit = unit
	self.is_ally = unit in battle_manager.player_party

	_reset_color()

	name_label.text = "%s" % [unit.unit_name]
	if unit.unit_data.portrait:
		portrait.texture = unit.unit_data.portrait

	self.battle_manager = battle_manager
	self.battle_manager.meta.hovered_unit_changed.connect(on_hevered_unit_changed)

	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)

func on_hevered_unit_changed(unit: Unit):
	if unit == self.unit:
		color_rect.color = hover_color
	else:
		_reset_color()

func _on_mouse_enter():
	battle_manager.meta.hovered_unit = unit

func _on_mouse_exit():
	battle_manager.meta.hovered_unit = null

func _reset_color():
	if is_ally:
		color_rect.color = ally_color
	else:
		color_rect.color = enemy_color
