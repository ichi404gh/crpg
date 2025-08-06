class_name DamageManager

var bm: BattleManager

var dmr: DamageModificatorRegistry = DamageModificatorRegistry.new()

func _init(bm: BattleManager):
	self.bm = bm

func apply_damage(source: Unit, target: Unit, damage: DamagePipeline, action: Action = null) -> Result:
	var res = Result.new()

	for mod: DealingDamageModificator in dmr.get_dealing_mods_for_unit(source):
		if not mod.mod_condition or mod.mod_condition.fits(source, target, bm, action):
			mod.modify(damage)
	for mod: ReceivingDamageModificator in dmr.get_receiving_mods_for_unit(target):
		if not mod.mod_condition or mod.mod_condition.fits(source, target, bm, action):
			mod.modify(damage)

	var reaction_events = apply_reaction(source, target, damage, bm)

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

func apply_reaction(source: Unit, target: Unit, damage: DamagePipeline, bm: BattleManager):
	var dt_reaction_context = ReactionContext.new()

	var damage_taken_reactions = bm.reaction_manager.get_on_damage_taken_reaction_for_unit(target)
	var reaction_events = []
	dt_reaction_context.bm = bm
	dt_reaction_context.damage = damage
	dt_reaction_context.source = target # damage receiver is reaction source
	dt_reaction_context.target = source # damage dealer is reaction target, but can be overriden

	for reaction: Reaction in damage_taken_reactions:
		reaction_events.append_array(reaction.apply(dt_reaction_context))


	if source:
		var damage_dealt_reactions = bm.reaction_manager.get_on_damage_dealt_reaction_for_unit(source)
		var dd_reaction_context = ReactionContext.new()
		dd_reaction_context.bm = bm
		dd_reaction_context.damage = damage
		dd_reaction_context.source = source
		dd_reaction_context.target = target
		for reaction: Reaction in damage_dealt_reactions:
			reaction_events.append_array(reaction.apply(dd_reaction_context))

	return reaction_events

class Result:
	var events: Array[AbstractBattleEvent] = []
	var final_damage: int
