class_name OffInteractionDamageEvent
extends AbstractBattleEvent

var target: Unit
var hp_change: int
var hurt: bool = false

func _to_string() -> String:
	return "off int damage: %s" % hp_change
