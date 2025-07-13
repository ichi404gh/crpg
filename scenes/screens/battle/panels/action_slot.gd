extends Control
class_name ActionSlot

#@onready var panel = $Node2D
@onready var hilight_rect: ColorRect = $HilightRect
#@onready var nine_patch_rect: NinePatchRect = $NinePatchRect
#@onready var node_2d: Node2D = $Node2D
@onready var panel: NinePatchRect = %Panel9P

var action: Action
var hilight: bool = false:
	set(value):
		hilight_rect.visible = value

signal action_set(action: Action)

func _can_drop_data(_at_position: Vector2, data: Variant):
	return data is Action

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var action = data as Action
	set_action(action)

func clear_slot():
	for c in panel.get_children():
		c.queue_free()


func set_action(action: Action):
	self.action = action
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
		if event.is_released() and action:
			set_action(null)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_END:
			hilight = false
