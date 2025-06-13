extends VBoxContainer
class_name TimelineUnitRow

@onready var unit_label: Label = $HBoxContainer/UnitLabel
@onready var unit_hp: Label = $HBoxContainer/UnitHP

@onready var timeline: Timeline = $".."
@onready var track: Panel = $Track

@onready var action_tick: Sprite2D = $Track/ActionOnTrack/ActionTick
@onready var action_end_tick: Sprite2D = $Track/ActionOnTrack/ActionEndTick

@onready var _pixels_per_sec: float

var battle_manager: BattleManager
var action : QueuedAction 
var unit: Unit

func set_unit(unit: Unit):
	self.unit = unit
	$HBoxContainer/UnitLabel.text = unit.unit_name
	$HBoxContainer/UnitHP.text = str(unit.hp)
	_update_action_markers()
	

func set_unit_hp(hp: int):
	$HBoxContainer/UnitHP.text = str(hp)

func set_action(action: QueuedAction):
	self.action = action

func _ready() -> void:
	battle_manager = timeline.battle_manager
	_pixels_per_sec = size.x / timeline.visible_seconds
	battle_manager.unit_damaged.connect(_on_unit_updated)


func _process(delta: float) -> void:
	if battle_manager.is_running and action:
		_update_action_markers()

func _update_action_markers():
	if action and action.source.alive:
		action_tick.position.x = action.prepare * _pixels_per_sec
		action_end_tick.position.x = action.recovery * _pixels_per_sec

func _on_unit_updated(unit: Unit):
	if unit == self.unit:
		set_unit_hp(unit.hp)
