
class_name TargetHpLessThanPercentModificatorCondition
extends ModificatorCondition

@export_range(0.0, 1.0, 0.1) var percent: float = 0.8

func fits(_source: Unit, target: Unit, _bm: BattleManager) -> bool:
	return target.hp <= target.unit_data.max_hp * percent
