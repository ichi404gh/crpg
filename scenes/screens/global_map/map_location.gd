extends Area2D

@export var localtion_data: LocationData

@onready var label: Label = $Label

signal clicked(data: LocationData)



func _ready() -> void:
	if localtion_data:
		setup(localtion_data)

func setup(localtion_data: LocationData):
	self.localtion_data = localtion_data
	label.text = localtion_data.label
	label.modulate.a = 0

	mouse_entered.connect(_on_mouse_enter)
	mouse_exited.connect(_on_mouse_exit)
	input_event.connect(_on_input_event)


func _on_mouse_enter():
	create_tween().tween_property(label, "modulate:a", 1.0, 0.3)

func _on_mouse_exit():
	create_tween().tween_property(label, "modulate:a", 0.0, 0.3)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self.localtion_data)
