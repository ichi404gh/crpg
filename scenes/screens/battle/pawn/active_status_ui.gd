class_name ActiveStatusUI
extends Control

@onready var status_texture: TextureRect = %StatusTexture

var status: Status

func _ready() -> void:
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_stop_hover)

func _on_hover():
	var data = StatusTooltipData.new()
	data.status = status
	TooltipManager.show(data, self)

func _on_stop_hover():
	TooltipManager.hide()

func setup(status: Status):
	self.status = status
	status_texture.texture = status.texture
