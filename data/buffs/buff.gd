class_name Buff
extends Resource

@export var title: String
@export var modificator_provider: ModificatorProvider
@export var targeting_provider: TargetingProvider

@export var ticks_before_round: bool = false
@export var ticks_after_round: bool = false


func tick(_target: Unit, _bm: BattleManager) -> Array[AbstractBattleEvent]:
	return []

func _get_description():
	return ""
