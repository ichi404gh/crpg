class_name ModificatorRegistry


var records: Array[Record] = []

func register(provider: ModificatorProvider, mods: Array[Modificator], for_units: Array[Unit]):
	for unit in for_units:
		for mod in mods:
			var record = Record.new()
			record.mod = mod
			record.provider = provider
			record.unit = unit

			records.append(record)

func unregister(provider: ModificatorProvider):
	records = records.filter(func (r: Record): return r.provider != provider)

class Record:
	var provider: ModificatorProvider
	var mod: Modificator
	var unit: Unit
