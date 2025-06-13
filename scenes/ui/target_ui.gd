extends MarginContainer

var on_selected: Callable
var target: Unit

func _ready() -> void:
	$Button.pressed.connect(_on_action_selected)
	
func _on_action_selected():
	if on_selected:
		on_selected.call(target)

func set_unit(unit: Unit):
	self.target = unit
	$Button.text = unit.unit_name
