class_name EveryAlly
extends TargetingStrategy

func get_targets(source: Unit, battle_manager: BattleManager) -> Array[Unit]:
	var pool = battle_manager._get_own_alive_party(source);
	return pool
