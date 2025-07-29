class_name RandomFromEnemyParty
extends TargetingStrategy

func get_targets(_source: Unit, battle_manager: BattleManager) -> Array[Unit]:
	var pool = battle_manager.enemy_party.filter(Unit.is_alive);

	var weighted = get_weighted(_source, pool, battle_manager)
	return pick_one(weighted)
