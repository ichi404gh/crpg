class_name StagePlan

var plan: Dictionary


func add(unit: Unit, actions: Array[Action]):
	plan[unit] = actions

func get_max_round() -> int:
	var current_max = 0
	for actions: Array[Action] in plan.values():
		current_max = max(current_max, actions.size())
	
	return current_max
