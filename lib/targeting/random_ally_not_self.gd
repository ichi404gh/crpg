class_name RandomAllyNotSelf
extends TargetingStrategy

func get_targets(source: Unit, battle_manager: BattleManager) -> Array[Unit]:
	var pool = battle_manager._get_own_alive_party(source).filter(func (u): return u != source);
	if pool.is_empty():
		return []
	return [pool.pick_random()]
