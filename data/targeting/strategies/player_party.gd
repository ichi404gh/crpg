class_name PlayerPartyTargetingStrategy
extends TargetingStrategy

func get_targets(_source: Unit, battle_manager: BattleManager) -> Array[Unit]:
	return battle_manager.player_party.filter(Unit.is_alive)
