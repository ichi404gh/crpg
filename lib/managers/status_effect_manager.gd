class_name StatusEffectManager

var bm: BattleManager


func _init(bm: BattleManager):
	self.bm = bm

func aplly_effect(target: Unit, status_effect: StatusEffect) -> Array[AbstractBattleEvent]:
	if target.have_status(status_effect):
		var status = target.find_applied_status(status_effect)
		status.duration = max(status.duration, status_effect.default_duration)
	else:
		target.status_effects.append(Unit.AppliedStatusEffect.new(status_effect, status_effect.default_duration))
	var ev = StatusEffectsUpdatedEvent.from_unit(target)
	return [ev]

func expire_effects(target: Unit) -> Array[AbstractBattleEvent]:
	var updated = false
	for effect in target.status_effects:
		effect.duration -= 1
		updated = true
	target.status_effects = target.status_effects.filter(func (ase: Unit.AppliedStatusEffect): return ase.duration > 0)
	if updated:
		var ev = StatusEffectsUpdatedEvent.from_unit(target)
		return [ev]
	return []
