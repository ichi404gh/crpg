extends Effect
class_name ApplyStatusEffects

@export var statuses: Array[Status]

func apply(_source: Unit, target: Unit, battle_manager: BattleManager, _action: Action) -> Array[AbstractBattleEvent]:
	var events: Array[AbstractBattleEvent] = []
	for status in statuses:
		events = battle_manager.status_effect_manager.aplly_status(target, status)
	return events

func _get_description():
	var descs = []
	for status in statuses:
		descs.append(tr(
					"action_effect.apply_status_effect.description"
				).format(
					{"effect": tr(status.title), "dur": status.duration}
				))
	return "\n".join(descs)
