class_name DamageManager

var bm: BattleManager

var dmr: DamageModificatorRegistry = DamageModificatorRegistry.new()

func _init(bm: BattleManager):
	self.bm = bm
	dmr.registry = bm.modificator_registry

func apply_damage(source: Unit, target: Unit, base_amount: int) -> Result:
	var res = Result.new()

	print("before mods: %s" % base_amount)
	var amount = base_amount
	for mod: DealingDamageModificator in dmr.get_dealing_mods_for_unit(source):
		amount = mod.modify(amount)
	for mod: ReceivingDamageModificator in dmr.get_receiving_mods_for_unit(target):
		amount = mod.modify(amount)

	amount = max(amount, 0)
	print("after mods: %s" % amount)
	res.final_damage = amount

	target.hp -= amount
	if target.hp <= 0:
		target.alive = false
		var event = UnitDeadEvent.new()
		event.who = target
		res.events.append(event)

	return res

class Result:
	var events: Array[AbstractBattleEvent] = []
	var final_damage: int
