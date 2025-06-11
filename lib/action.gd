extends Resource
class_name Action

@export var prepare: float
@export var recovery: float
@export var cooldown: float

@export var action_name: String

var done: bool = false
var recovered: bool = false


func _init(_action_name: String, _prepare: float, _recovery: float, _cooldown: float = 0) -> void:
	prepare = _prepare
	recovery = _recovery
	cooldown = _cooldown
	action_name = _action_name
