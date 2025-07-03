extends Node2D

@onready var texture_rect: TextureRect = $TextureRect

var action: Action


func _ready() -> void:
	texture_rect.texture = action.texture
