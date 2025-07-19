class_name StatusEffectManager

var bm: BattleManager


func _init(bm: BattleManager):
	self.bm = bm

func aplly_status(target: Unit, status: Status) -> Array[AbstractBattleEvent]:
	if target.have_status(status):
		var unit_status = target.find_applied_status(status)
		unit_status.duration = max(unit_status.duration, status.duration)
	else:
		target.status_effects.append(status.duplicate())
		for buff in status.buffs:
			if buff.modificator_provider is ModificatorProvider:
				bm.modificator_registry.register(buff.modificator_provider, buff.modificator_provider.provides, [target])
	var ev = StatusEffectsUpdatedEvent.from_unit(target)
	return [ev]

func expire_statuses(target: Unit) -> Array[AbstractBattleEvent]:
	for effect in target.status_effects:
		if effect.duration and not effect.uses:
			effect.duration -= 1

	return clean(target)

func decrement_uses_by_reaction(target: Unit, reaction: Reaction):
	for status in target.status_effects:
		if reaction in status.reactions:
			if status.uses and not status.duration:
				status.uses -= 1
	return clean(target)

func clean(target: Unit) -> Array[AbstractBattleEvent]:
	var to_remove = target.status_effects.filter(func (s: Status): return s.duration <= 0 and s.uses <= 0)
	if not to_remove:
		return []
	for status in to_remove:
		for buff in status.buffs:
			if buff.modificator_provider is ModificatorProvider:
				bm.modificator_registry.unregister(buff.modificator_provider)
		target.status_effects.erase(status)

	var ev = StatusEffectsUpdatedEvent.from_unit(target)
	return [ev]
