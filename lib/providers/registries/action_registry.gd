extends Node

var records: Array[Record] = []


func register(provider: ActionProvider, for_units: Array[Unit]):
	for unit in for_units:
		for action in provider.provides:
			var record = Record.new()
			record.unit = unit
			record.action = action
			record.provider = provider
			records.append(record)


func unregister(provider: ActionProvider):
	records = records.filter(func (r: Record): return r.provider != provider)


func get_actions_for_unit(unit: Unit) -> Array[Action]:
	var res: Array[Action] = []
	for r in records:
		if r.unit == unit:
			res.append(r.action)
	return res


class Record:
	var unit: Unit
	var action: Action
	var provider: ActionProvider
