class_name RandomEnemy
extends TargetingStrategy

func get_targets(source: Unit, battle_manager: BattleManager) -> Array[Unit]:
	var pool = battle_manager._get_opposite_alive_party(source);
	if pool.is_empty():
		return []
	return [pool.pick_random()]
