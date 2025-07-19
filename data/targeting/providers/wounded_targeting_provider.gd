class_name WoundedTargetingProvider
extends TargetingProvider

@export_range(0.0, 1.0, 0.1) var threshold_percent: float = 0.8

func matches(target: Unit, _bm: BattleManager) -> bool:
	return target.hp <= target.unit_data.max_hp * threshold_percent
