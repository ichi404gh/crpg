@abstract class_name CombatEvent

class Attacks extends CombatEvent:
	var source: Unit
	var target: Unit
	var damage: int
	var effect_scene: PackedScene

	func _to_string() -> String:
		return "AttackEvent[%s - %s: %s dmg]" % [source, target, damage]

class Dies extends CombatEvent:
	var who: Unit

	func _to_string() -> String:
		return "DiesEvent[%s]" % who

class Interact extends CombatEvent:
	var target: Unit
	var damage: int
	var effect_scene: PackedScene

	func _to_string() -> String:
		return "InteractEvent[]"

static func attacks(source: Unit, target: Unit, damage: int = 0, effect_scene: PackedScene = null):
	var e := Attacks.new()
	e.source = source
	e.target = target
	e.damage = damage
	e.effect_scene = effect_scene
	return e

static func dies(who: Unit):
	var e := Dies.new()
	e.who = who
	return e

static func interact(target: Unit, damage: int = 0, effect_scene: PackedScene = null):
	var e := Interact.new()
	e.target = target
	e.effect_scene = effect_scene
	e.damage = damage
	return e
