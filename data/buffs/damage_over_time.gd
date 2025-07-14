class_name DamageOverTimeEffect
extends Buff

@export var damage: int

func tick(target: Unit, battle_manager: BattleManager) -> Array[AbstractBattleEvent]:
	var events: Array[AbstractBattleEvent] = []


	var damage_result = battle_manager.damage_mananger.apply_damage(null, target, damage)


	var ev = OffInteractionDamageEvent.new()
	ev.target = target
	ev.hp_change = -damage_result.final_damage

	events.append(ev)

	events.append_array(damage_result.events)

	return events

func _get_description():
	return tr("status_effect.damage_over_time.description").format({dmg=damage})
