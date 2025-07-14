class_name DamageModificatorRegistry


var registry: ModificatorRegistry

func get_dealing_mods_for_unit(unit: Unit) -> Array[DealingDamageModificator]:
	var res: Array[DealingDamageModificator] = []

	for record in registry.records:
		if record.mod is DealingDamageModificator and record.unit == unit:
			res.append(record.mod)
	return res


func get_receiving_mods_for_unit(unit: Unit)-> Array[ReceivingDamageModificator]:
	var res: Array[ReceivingDamageModificator] = []

	for record in registry.records:
		if record.mod is ReceivingDamageModificator and record.unit == unit:
			res.append(record.mod)
	return res
