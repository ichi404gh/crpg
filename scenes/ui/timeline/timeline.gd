extends Control
class_name Timeline

@export var battle_manager: BattleManager
@export var visible_seconds: float = 6.0 

var units_tracks: Dictionary[Unit, TimelineUnitRow] = {}

func _ready() -> void:
	battle_manager.units_updated.connect(on_units_updated)
	battle_manager.card_played.connect(on_card_played)
	battle_manager.unit_damaged.connect(_on_unit_damaged)

func add_unit_track(unit: Unit) -> TimelineUnitRow:
	var row = preload("res://scenes/ui/timeline/timeline_unit_row.tscn").instantiate()
	row.set_unit(unit)
	add_child(row)
	return row

func reset():
	for child in get_children():
		remove_child(child)

func on_units_updated(pp: Array[Unit], ep: Array[Unit]):
	reset()
	units_tracks.clear()
	
	for unit in pp:
		var track = add_unit_track(unit)
		units_tracks[unit] = track
	
	for unit in ep:
		var track = add_unit_track(unit)
		units_tracks[unit] = track

func on_card_played(card: QueuedAction):
	var track = units_tracks[card.source]
	track.set_action(card)

func _on_unit_damaged(unit: Unit, current_hp: int):
	var unit_row = units_tracks[unit]
	unit_row.unit_hp.text = current_hp
