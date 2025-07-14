class_name SelfTargeting
extends TargetingStrategy

func get_targets(source: Unit, _battle_manager: BattleManager) -> Array[Unit]:
	return [source]
