extends Control

var action: Action

signal selected(action: Action)
signal dragging


func setup(action: Action):
	self.action = action
	%TextureRect.texture = action.texture
	%Label.text = action.title
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_stop_hover)

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview = TextureRect.new()
	preview.size = Vector2(20, 20)
	preview.texture = action.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	dragging.emit()

	set_drag_preview(preview)
	return action

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released():
			selected.emit(action)

func _on_hover():
	var data = ActionTooltipData.new()
	data.action = action
	TooltipManager.show(data, self)

func _on_stop_hover():
	TooltipManager.hide()
