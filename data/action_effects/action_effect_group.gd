class_name ActionEffectGroup
extends Resource

@export var targeting: TargetingStrategy
@export var effects: Array[ActionEffect]


func get_targets(source: Unit, battle_manager: BattleManager) -> Array[Unit]:
	return targeting.get_targets(source, battle_manager)

func have_targets(source: Unit, battle_manager: BattleManager) -> bool:
	return not get_targets(source, battle_manager).is_empty()
