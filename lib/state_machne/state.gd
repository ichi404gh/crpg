extends Node
class_name StateMachineState

signal transitioned(from: StateMachineState, to_name: String)

func enter():
	pass

func exit():
	pass

func process_state(delta: float):
	pass

func physics_process_state(delta: float):
	pass
