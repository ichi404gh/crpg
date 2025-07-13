extends ActionEffect
class_name ApplyStatusEffects

@export var effects: Array[StatusEffect]

func apply(_source: Unit, target: Unit, battle_manager: BattleManager, _action: Action) -> Array[AbstractBattleEvent]:
	var events = []
	for effect in effects:
		events = battle_manager.status_effect_manager.aplly_effect(target, effect)
	return events

func _get_description():
	var descs = []
	for effect in effects:
		descs.append(tr("action_effect.apply_status_effect.description").format({"effect": tr(effect.title), "dur": effect.default_duration}))
	return "\n".join(descs)
