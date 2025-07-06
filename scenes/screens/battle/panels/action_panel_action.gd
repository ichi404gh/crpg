extends Control

var action: Action


func setup(action: Action):
	self.action = action
	%TextureRect.texture = action.texture
	%Label.text = action.title

func _get_drag_data(at_position: Vector2) -> Variant:
	var preview = TextureRect.new()
	preview.size = Vector2(20, 20)
	preview.texture = action.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE


	set_drag_preview(preview)
	return action
