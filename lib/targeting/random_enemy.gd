class_name RandomEnemy
extends TargetingStrategy

func get_targets(source: Unit, battle_manager: BattleManager) -> Array[Unit]:
	var pool = battle_manager._get_opposite_alive_party(source);
	if pool.is_empty():
		return []

	var weighted = get_weighted(source, pool, battle_manager)
	return pick_one(weighted)
