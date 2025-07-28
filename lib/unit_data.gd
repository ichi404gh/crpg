extends Resource
class_name UnitData

@export var name: String
@export var max_hp: int

@export var unit_ui: PackedScene
@export var portrait: Texture2D
@export var action_points: int = 3

@export var action_set: ActionSet

func instantiate() -> Unit:
	var unit: Unit = Unit.new()
	unit.hp = max_hp
	unit.unit_name = name
	unit.unit_data = self
	return unit
