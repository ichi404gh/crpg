extends ActionEffect
class_name ApplyStatusEffects

@export var effects: Array[StatusEffect]

func apply(_source: Unit, target: Unit, battle_manager: BattleManager, _action: Action) -> Array[AbstractBattleEvent]:
	for effect in effects:
		battle_manager.status_effect_manager.aplly_effect(target, effect)
	return []
