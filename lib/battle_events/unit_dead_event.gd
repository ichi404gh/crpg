class_name UnitDeadEvent
extends AbstractBattleEvent

var who: Unit

func _to_string() -> String:
	return "%s dies" % [who.unit_name]
