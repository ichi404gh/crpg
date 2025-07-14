class_name StatusEffectsUpdatedEvent
extends AbstractBattleEvent

var target: Unit
var effects: Array[Status]

func _to_string() -> String:
	return "StatusEffectsUpdated %s" % [effects]

static func from_unit(target: Unit) -> StatusEffectsUpdatedEvent:
	var ev = StatusEffectsUpdatedEvent.new()
	ev.target = target
	ev.effects = target.status_effects
	return ev
