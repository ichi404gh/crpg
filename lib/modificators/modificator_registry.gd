class_name ModificatorRegistry


var records: Array[Record] = []

func register(provider: ModificatorProvider, for_units: Array[Unit]):
	print("registering provider")
	for unit in for_units:
		for mod in provider.provides:
			var record = Record.new()
			record.mod = mod
			record.provider = provider
			record.unit = unit

			records.append(record)

func unregister(provider: ModificatorProvider):
	print("unregistering provider")

	records = records.filter(func (r: Record): return r.provider != provider)

class Record:
	var provider: ModificatorProvider
	var mod: Modificator
	var unit: Unit
