@abstract
extends Resource
class_name ActionEffect

@abstract
func apply(source: Unit, target: Unit, battle_manager: BattleManager, action: Action) -> Array[AbstractBattleEvent]

func _get_description():
	return ""
