extends Resource
class_name ActionCard

@export var name: String
@export var prepare_time: float = 0.3
@export var recover_time: float = 0.5
@export var effects: Array[ActionEffect] = []  # типа урона и т.п.
@export var target_type: String = "enemy"  # пока просто: "enemy" или "self"
