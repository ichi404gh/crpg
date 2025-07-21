extends Control

signal clicked(order: Order)

@onready var title: Label = %Title
@onready var description: RichTextLabel = %Description

var hovered: bool = false
var order: Order

func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func setup(order):
	self.order = order
	title.text = order.title
	description.text = order.description

func on_mouse_entered():
	hovered = true
	var tween = create_tween()
	await tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.05).finished

func on_mouse_exited():
	hovered = false
	var tween = create_tween()
	await tween.tween_property(self, "scale", Vector2(1, 1), 0.05).finished

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and hovered:
		if (event.button_index == MOUSE_BUTTON_LEFT) and event.pressed:
			clicked.emit(self.order)
