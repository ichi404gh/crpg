extends ActionEffect
class_name HealEffect

@export var amount: int = 5

func apply(_source: Unit, target: Unit, battle_manager: BattleManager):
	return battle_manager.apply_damage(target, -amount)
