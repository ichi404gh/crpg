extends VBoxContainer
class_name TimelineUnitRow

@onready var unit_label: Label = $UnitLabel
@onready var timeline: Timeline = $".."
@onready var track: Panel = $Track

@onready var action: Control = $Track/ActionOnTrack

@onready var action_tick: Sprite2D = $Track/ActionOnTrack/ActionTick
@onready var action_end_tick: Sprite2D = $Track/ActionOnTrack/ActionEndTick

@onready var _pixels_per_sec: float

var unit_name: String
var battle_manager: BattleManager
var _action : QueuedAction 

func set_unit_name(name: String):
	unit_name = name


func _ready() -> void:
	unit_label.text = unit_name
	battle_manager = timeline.battle_manager
	_pixels_per_sec = size.x / timeline.visible_seconds



func set_action(action: QueuedAction):
	_action = action
	_update_action_markers()


func _process(delta: float) -> void:
	if battle_manager.is_running and _action:
		_update_action_markers()
		
func _update_action_markers():
	if _action:
		action_tick.position.x = _action.prepare * _pixels_per_sec
		action_end_tick.position.x = _action.recovery * _pixels_per_sec
