extends Control

@onready var hilight_rect: ColorRect = %HilightRect
@onready var panel: NinePatchRect = %Panel9P

signal cleared

var action: Action
#var hilight: bool = false:
	#set(value):
		#hilight_rect.visible = value

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


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released() and action:
			cleared.emit()
