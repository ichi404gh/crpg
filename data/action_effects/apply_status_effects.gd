extends ActionEffect
class_name ApplyStatusEffects

@export var effects: Array[StatusEffect]

func apply(_source: Unit, target: Unit, battle_manager: BattleManager, _action: Action):
	for effect in effects:
		battle_manager.apply_status_effect(target, effect)
