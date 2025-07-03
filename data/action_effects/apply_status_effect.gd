extends ActionEffect
class_name ApplyStatusEffect

@export var effect: StatusEffect
@export var duration: float

func apply(source: Unit, target: Unit, battle_manager: BattleManager):
	battle_manager.apply_status_effect(target, effect, duration)
