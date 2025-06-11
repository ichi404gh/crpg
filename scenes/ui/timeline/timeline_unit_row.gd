extends VBoxContainer
class_name TimelineUnitRow

@onready var unit_label: Label = $UnitLabel
@onready var timeline: Timeline = $".."
@onready var track: Panel = $Track

@onready var action: Control = $Track/ActionOnTrack

@onready var action_tick: Sprite2D = $Track/ActionOnTrack/ActionTick
@onready var action_end_tick: Sprite2D = $Track/ActionOnTrack/ActionEndTick

signal action_ended(action: Action)
signal action_hit(action: Action)

var unit_name: String
var battle_manager: BattleManager
var _action : Action 
var _pixels_per_sec := 100.0
var track_y_coord: float

const speed = 50
func set_unit_name(name: String):
	unit_name = name


func _ready() -> void:
	unit_label.text = unit_name
	battle_manager = timeline.battlee_manager
	_pixels_per_sec = size.x / timeline.visible_seconds
	_update_action_markers()
	queue_redraw()



func set_action(action: Action):
	_action = action


func _process(delta: float) -> void:
	if battle_manager.is_running and _action:
		_action.prepare -= delta
		if _action.prepare <= 0 and !_action.done:
			_action.done = true
			action_hit.emit(_action)
		_action.recovery -= delta
		if _action.recovery <= 0 and !_action.recovered:
			_action.recovered = true
			action_ended.emit(_action)
		_action.cooldown -= delta

		_update_action_markers()
		
func _update_action_markers():
	if _action:
		action_tick.position.x = _action.prepare * _pixels_per_sec
		action_end_tick.position.x = _action.recovery * _pixels_per_sec
