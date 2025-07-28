class_name HaveWoundedAlliesNotSelf extends ActionDesirabilityEvaluator

@export_range(0.0, 1.0) var threshold: float = 0.8
@export_range(0.0, 5.0) var weight_match: float = 1.0
@export_range(0.0, 5.0) var weight_not_match: float = 1.0

func evaluate(source: Unit, battle_manager: BattleManager) -> float:
	var party = battle_manager._get_own_alive_party(source)
	for unit in party:
		if unit == source:
			continue
		if unit.hp / float(unit.unit_data.max_hp) <= threshold:
			return weight_match
	return weight_not_match
