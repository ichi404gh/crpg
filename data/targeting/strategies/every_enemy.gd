class_name EveryEnemy
extends TargetingStrategy

func get_targets(source: Unit, battle_manager: BattleManager) -> Array[Unit]:
	var pool = battle_manager._get_opposite_alive_party(source);
	return pool
