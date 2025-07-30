extends Effect
class_name ApplyStatusEffects

@export var statuses: Array[Status]

func apply(_source: Unit, target: Unit, battle_manager: BattleManager, _action: Action = null) -> Array[AbstractBattleEvent]:
	var events: Array[AbstractBattleEvent] = []
	for status in statuses:
		events = battle_manager.status_effect_manager.aplly_status(target, status)
	return events

func _get_description():
	var descs = []
	for status in statuses:

		var duration = ""
		if status.duration:
			duration = tr("action_effect.apply_status_effect.duration").format(
				{
					"dur": status.duration,
					"round_plural": PluralHelper.plural("action_effect.plural.round", status.duration),
				})
		if status.uses:
			duration = tr("action_effect.apply_status_effect.uses").format(
				{
					"uses": status.uses,
					"uses_plural": PluralHelper.plural("action_effect.plural.uses", status.uses)
				})
		descs.append(tr(
					"action_effect.apply_status_effect.description"
				).format(
					{"effect": tr(status.title)}
				) + duration)

	return "\n".join(descs)
