extends Control
class_name Timeline

@export var battle_manager: BattleManager
@export var visible_seconds: float = 6.0 

var units_tracks: Dictionary[Unit, TimelineUnitRow] = {}

func _ready() -> void:
	battle_manager.units_updated.connect(on_units_updated)
	battle_manager.card_played.connect(on_card_played)

func add_unit_track(unit_name: String) -> TimelineUnitRow:
	var row = preload("res://scenes/ui/timeline/timeline_unit_row.tscn").instantiate()
	row.set_unit_name(unit_name)
	add_child(row)
	return row

func reset():
	for child in get_children():
		remove_child(child)

func on_units_updated(pp: Array[Unit], ep: Array[Unit]):
	reset()
	units_tracks.clear()
	
	for unit in pp:
		var track = add_unit_track(unit.unit_name)
		units_tracks[unit] = track
	
	for unit in ep:
		var track = add_unit_track(unit.unit_name)
		units_tracks[unit] = track

func on_card_played(card: QueuedAction):
	var track = units_tracks[card.source]
	track.set_action(card)
