class_name SelfWounded extends ActionDesirabilityEvaluator

@export_range(0.0, 1.0) var threshold: float = 0.8
@export_range(0.0, 5.0) var weight_match: float = 1.0
@export_range(0.0, 5.0) var weight_not_match: float = 1.0

func evaluate(source: Unit, _battle_manager: BattleManager) -> float:
	if source.hp / float(source.total_max_hp) <= threshold:
		return weight_match
	return weight_not_match
