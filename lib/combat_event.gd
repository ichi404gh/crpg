class_name CombatEvent

func _to_string() -> String:
	return JSON.stringify(event)

var event

static func attack(source: Unit, target: Unit, damage: int):
	var e = CombatEvent.new()
	e.event = {
		"kind": "attack",
		"source": source,
		"target": target,
		"damage": damage,
	}
	return e

static func dies(who: Unit):
	var e = CombatEvent.new()
	e.event = {
		"kind": "dies",
		"who": who,
	}
	return e
