@abstract
extends Resource
class_name ActionEffect

@export var targeting: TargetingStrategy

@abstract
func apply(source: Unit, target: Unit, battle_manager: BattleManager, action: Action) -> Array[AbstractBattleEevnt]

func get_targets(source: Unit, battle_manager: BattleManager) -> Array[Unit]:
	return targeting.get_targets(source, battle_manager)

func have_targets(source: Unit, battle_manager: BattleManager) -> bool:
	return not get_targets(source, battle_manager).is_empty()
