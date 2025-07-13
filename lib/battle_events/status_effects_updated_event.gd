class_name StatusEffectsUpdatedEvent
extends AbstractBattleEvent

var target: Unit
var effects: Array[Unit.AppliedStatusEffect]

func _to_string() -> String:
	return "StatusEffectsUpdated %s" % [effects]

static func from_unit(target: Unit) -> StatusEffectsUpdatedEvent:
	var ev = StatusEffectsUpdatedEvent.new()
	ev.target = target
	ev.effects = [] as Array[Unit.AppliedStatusEffect]
	for e: Unit.AppliedStatusEffect in ev.target.status_effects:
		ev.effects.append(Unit.AppliedStatusEffect.new(e.status_effect, e.duration))
	return ev
