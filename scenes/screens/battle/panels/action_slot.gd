extends Control
class_name ActionSlot

@onready var panel: Panel = $Panel

var _action: Action

signal action_set(action: Action)

func _can_drop_data(_at_position: Vector2, data: Variant):
	return data is Action

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var action = data as Action
	set_action(action)
	print("drag end")

func clear_slot():
	for c in panel.get_children():
		c.queue_free()


func set_action(action: Action):
	self._action = action
	for c in panel.get_children():
			c.queue_free()
	if action:
		var texture_rect = TextureRect.new()
		texture_rect.texture = action.texture
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		panel.add_child(texture_rect)
	action_set.emit(action)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released() and _action:
			set_action(null)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_END:
			print('end')
