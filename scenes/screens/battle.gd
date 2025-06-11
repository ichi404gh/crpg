extends Node2D


@onready var timeline: Timeline = $CanvasLayer/Control/Timeline

var t1: TimelineUnitRow
var t2: TimelineUnitRow

func _ready():
	timeline.reset()
	
	t1 = timeline.add_unit_track("Player") 
	t1.set_action(Action.new("Wind-Up", 1, 3))
	t1.action_ended.connect(new_t1_action)

	t2 = timeline.add_unit_track("Enemy")
	t2.set_action(Action.new("Block", 2, 3))
	t2.action_ended.connect(new_t2_action)
	
	t1.action_hit.connect(hit)
	t2.action_hit.connect(hit)

	
func new_t1_action(a):
	var r = randf_range(0.5, 2.5)
	t1.set_action(Action.new("Wind-Up", r, r + randf_range(0.5, 1)))
	
func new_t2_action(a):
	var r = randf_range(0.5, 2.5)

	t2.set_action(Action.new("Block-Up", r, r + randf_range(0.5, 1)))
	
func hit(a: Action):
	print(a.action_name)
