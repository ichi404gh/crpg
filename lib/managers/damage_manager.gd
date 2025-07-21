class_name DamageManager

var bm: BattleManager

var dmr: DamageModificatorRegistry = DamageModificatorRegistry.new()

func _init(bm: BattleManager):
	self.bm = bm
	dmr.registry = bm.modificator_registry

func apply_damage(source: Unit, target: Unit, damage: DamagePipeline) -> Result:
	var res = Result.new()

	for mod: DealingDamageModificator in dmr.get_dealing_mods_for_unit(source):
		if not mod.mod_condition or mod.mod_condition.fits(source, target, bm):
			mod.modify(damage)
	for mod: ReceivingDamageModificator in dmr.get_receiving_mods_for_unit(target):
		if not mod.mod_condition or mod.mod_condition.fits(source, target, bm):
			mod.modify(damage)

	var reactions = bm.reaction_manager.get_on_damage_taken_reaction_for_unit(target)

	var reaction_context = ReactionContext.new()
	reaction_context.bm = bm
	reaction_context.damage = damage
	reaction_context.source = target # damage receiver is reaction source
	reaction_context.target = source # damage dealer is reaction target, but can be overriden

	var reaction_events = []
	for reaction: Reaction in reactions:
		reaction_events.append_array(reaction.apply(reaction_context))

	damage.resolve()
	res.final_damage = damage.resolved_value

	target.hp -= damage.resolved_value
	if target.hp <= 0:
		target.alive = false
		var event = UnitDeadEvent.new()
		event.who = target
		res.events.append(event)
	res.events.append_array(reaction_events)
	return res

class Result:
	var events: Array[AbstractBattleEvent] = []
	var final_damage: int
