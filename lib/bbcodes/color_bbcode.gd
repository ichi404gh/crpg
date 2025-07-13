@tool
class_name ColorBBCode
extends RichTextEffect

@export var color: Color = "#d22"
@export var bbcode = "dmg"

func _process_custom_fx(char_fx):
	char_fx.color = color
	return true
