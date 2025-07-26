extends Control

var action: Action

signal selected(action: Action)

var disabled: bool = false

@onready var cooldown_label: Label = %CooldownLabel

func setup(action: ActionManager.ActionInstance):
	self.action = action.action
	%TextureRect.texture = action.action.texture
	%Label.text = action.action.title
	disabled = action.cooldown > 0

	if disabled:
		cooldown_label.text = str(action.cooldown)
		cooldown_label.show()
	else:
		cooldown_label.hide()


	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_stop_hover)


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
