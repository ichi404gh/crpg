class_name ConstantDesirabilityEvaluator extends ActionDesirabilityEvaluator

@export var value: float = 1.0

func evaluate(_source: Unit, _battle_manager: BattleManager) -> float:
	return value
