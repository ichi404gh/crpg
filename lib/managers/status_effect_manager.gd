class_name StatusEffectManager

var bm: BattleManager


func _init(bm: BattleManager):
	self.bm = bm

func aplly_effect(target: Unit, status_effect: StatusEffect):
	if target.have_status(status_effect):
		var status = target.find_applied_status(status_effect)
		status.duration = max(status.duration, status_effect.default_duration)
	else:
		target.status_effects.append(Unit.AppliedStatusEffect.new(status_effect, status_effect.default_duration))

func expire_effects(target: Unit):
	for effect in target.status_effects:
		effect.duration -= 1
	target.status_effects = target.status_effects.filter(func (ase: Unit.AppliedStatusEffect): return ase.duration > 0)
