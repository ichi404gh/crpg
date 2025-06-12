extends Resource
class_name ActionCard

@export var name: String
@export var prepare_time: float = 0.3
@export var recover_time: float = 0.5
@export var effects: Array[ActionEffect] = []  # типа урона и т.п.
@export var target_type: String = "enemy"  # пока просто: "enemy" или "self"

static func build(
	name: String, 
	prepare_time: float,
	recover_time: float, 
	effects: Array[ActionEffect] = [], 
	target_type: String = "enemy",
) -> ActionCard:
	var c = ActionCard.new()
	c.name = name
	c.prepare_time = prepare_time
	c.recover_time = recover_time
	c.effects = effects
	c.target_type = target_type
	return c
