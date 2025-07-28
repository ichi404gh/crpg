extends Node2D

signal clicked(order: Order)

@onready var title: Label = %Title
@onready var description: RichTextLabel = %Description
@onready var texture: TextureRect = %Texture
@onready var panel_container: PanelContainer = %PanelContainer

var hovered: bool = false
var order: Order


func _ready() -> void:
	panel_container.mouse_entered.connect(on_mouse_entered)
	panel_container.mouse_exited.connect(on_mouse_exited)
	set_selected(false)


func setup(order: Order):
	self.order = order
	title.text = order.title
	description.text = order.description
	texture.texture = order.texture

func on_mouse_entered():
	TooltipManager.show(OrderTooltipData.new(order), self)
	panel_container.z_index = 1
	hovered = true
	var tween = create_tween()
	await tween.tween_property(panel_container, "scale", Vector2(1.1, 1.1), 0.05).finished

func on_mouse_exited():
	TooltipManager.hide()
	panel_container.z_index = 0

	hovered = false
	var tween = create_tween()
	await tween.tween_property(panel_container, "scale", Vector2(1, 1), 0.05).finished

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and hovered:
		if (event.button_index == MOUSE_BUTTON_LEFT) and event.pressed:
			clicked.emit(self.order)

func set_selected(value: bool):
	const BROWN_PANELS = preload("uid://d1pqb4wth7tas")
	const GOLDEN_PANELS = preload("uid://l7sf8j0owpre")

	if value:
		panel_container.theme = GOLDEN_PANELS
	else:
		panel_container.theme = BROWN_PANELS
