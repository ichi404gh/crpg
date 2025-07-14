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
	var ev = StatusEffectsUpdatedEvent.from_unit(target)
	return [ev]

func expire_statuses(target: Unit) -> Array[AbstractBattleEvent]:
	var updated = false
	for effect in target.status_effects:
		effect.duration -= 1
		updated = true
	var to_remove = target.status_effects.filter(func (s: Status): return s.duration <= 0)
	for status in to_remove:
		# unsubscribe provider
		target.status_effects.erase(status)
	if updated:
		var ev = StatusEffectsUpdatedEvent.from_unit(target)
		return [ev]
	return []
