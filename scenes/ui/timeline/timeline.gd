extends Control
class_name Timeline

@export var battlee_manager: BattleManager
@export var visible_seconds: float = 6.0 



func add_unit_track(unit_name: String) -> TimelineUnitRow:
	var row = preload("res://scenes/ui/timeline/timeline_unit_row.tscn").instantiate()
	row.set_unit_name(unit_name)
	add_child(row)
	return row

func reset():
	for child in get_children():
		remove_child(child)
