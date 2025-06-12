extends Control

var on_selected: Callable
var action: ActionCard

func _ready() -> void:
	$Button.pressed.connect(_on_action_selected)
	
func _on_action_selected():
	if on_selected:
		on_selected.call(action)

func set_action(action: ActionCard):
	self.action = action
	$Button.text = action.name
