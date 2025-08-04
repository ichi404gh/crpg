extends PanelContainer

@onready var texture_rect: TextureRect = %TextureRect
@onready var label: Label = %Label

signal clicked(unit: Unit)

var unit: Unit
var hovering: bool = false


func _ready() -> void:
	mouse_entered.connect(on_mouse_enter)
	mouse_exited.connect(on_mouse_exit)

func on_mouse_enter():
	create_tween().tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)
	hovering = true

func on_mouse_exit():
	create_tween().tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	hovering = false

func setup(unit: Unit):
	self.unit = unit
	texture_rect.texture = unit.unit_data.portrait
	label.text = unit.unit_name

func _input(event: InputEvent) -> void:
	if hovering and  event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(unit)
