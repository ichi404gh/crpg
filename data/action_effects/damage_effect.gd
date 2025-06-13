extends ActionEffect
class_name DamageEffect

@export var amount: int = 5

func apply(source: Unit, target: Unit, battle_manager: BattleManager):
	battle_manager.apply_damage(target, amount)
