extends Panel

@onready var timeline_row: TimelineUnitRow = $".."


func _action_x(at_time: float) -> float:
	return (at_time) * timeline_row._pixels_per_sec


func _draw():
	#var t_start = floor(timeline_row.timeline.battlee_manager.battle_time)
	#var t_end   = timeline_row.timeline.battlee_manager.battle_time + timeline_row.timeline.visible_seconds
	for t in range(0, ceil(timeline_row.timeline.visible_seconds)):
		var x = _action_x(t)
		draw_dashed_line(Vector2(x, 0), Vector2(x,size.y), Color.WEB_GRAY)
