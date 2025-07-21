extends Control

@onready var texture: TextureRect = %Texture

func setup(order: Order):
	if not order:
		texture.texture = NoiseTexture2D.new()
	else:
		texture.texture = order.texture
