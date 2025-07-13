class_name DamageOverTimeEffect
extends StatusEffect

@export var damage: int

func tick(target: Unit, battle_manager: BattleManager) -> Array[AbstractBattleEvent]:
	var events: Array[AbstractBattleEvent] = []
	var ev = OffInteractionDamageEvent.new()
	ev.target = target
	ev.hp_change = -damage
	events.append(ev)

	var additional_events = battle_manager.damage_mananger.apply_damage(target, damage)
	events.append(additional_events)

	return events
