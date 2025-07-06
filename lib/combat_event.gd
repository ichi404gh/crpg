@abstract class_name CombatEvent

class Attacks extends CombatEvent:
	var source: Unit
	var target: Unit
	var damage: int

	func _to_string() -> String:
		return "AttackEvent[%s - %s: %s dmg]" % [source, target, damage]

class Dies extends CombatEvent:
	var who: Unit

	func _to_string() -> String:
		return "DiesEvent[%s]" % who

static func attacks(source: Unit, target: Unit, damage: int):
	var e := Attacks.new()
	e.source = source
	e.target = target
	e.damage = damage
	return e

static func dies(who: Unit):
	var e := Dies.new()
	e.who = who
	return e
