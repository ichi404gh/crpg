extends Node
class_name StateMachine

@export var initial_state: StateMachineState
var current_state: StateMachineState
var states: Dictionary[String, StateMachineState] = {}

func _init():
	_load_states()


func _load_states():
	for child in get_children():
		if child is StateMachineState:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transitioned)
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.process_state(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process_state(delta)

func on_child_transitioned(from: StateMachineState, to_name: String):
	if from != current_state:
		return
		
	var new_state = states.get(to_name.to_lower())
	if !new_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
