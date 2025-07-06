extends Node
class_name ActionManager


static func get_actions_for_unit(_unit: Unit) -> Array[Action]:
	return [
		preload("res://data/actions/sword_slash.tres"),
		preload("res://data/actions/quantum_healing.tres"),
		preload("res://data/actions/sword_slash.tres"),
	]
