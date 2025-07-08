class_name PreparedActionUI
extends Control

@onready var action_texture: TextureRect = %ActionTexture

var action: Action

func _ready() -> void:
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_stop_hover)

func _on_hover():
	var data = ActionTooltipData.new()
	data.action = action
	TooltipManager.show(data, self)

func _on_stop_hover():
	TooltipManager.hide()

func setup(action: Action):
	self.action = action
	action_texture.texture = action.texture
