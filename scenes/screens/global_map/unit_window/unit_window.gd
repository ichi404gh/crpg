class_name UnitWindow
extends PanelContainer

signal closed

@onready var name_label: Label = %NameLabel
@onready var close_button: Button = %CloseButton


var unit: Unit

func _ready() -> void:
	close_button.pressed.connect(closed.emit)

func setup(unit: Unit):
	self.unit = unit
	name_label.text = unit.unit_name
