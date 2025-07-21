class_name TargetingRegistry


var records: Array[Record] = []

func register(provider: TargetingProvider, for_units: Array[Unit]):
	for unit in for_units:
		for rule in provider.provides:
			var r = Record.new()
			r.provider = provider
			r.unit = unit
			r.rule = rule
			records.append(r)

func unregister(provider: TargetingProvider):
	records = records.filter(func(r: Record): return r.provider != provider)

func get_for_unit(unit: Unit) -> Array[TargetingRule]:
	var res: Array[TargetingRule] = []
	for rule in  records \
		.filter(func (r: Record): return r.unit == unit) \
		.map(func (r: Record): return r.rule):
			res.append(rule)
	return res

class Record:
	var provider: TargetingProvider
	var unit: Unit
	var rule: TargetingRule
