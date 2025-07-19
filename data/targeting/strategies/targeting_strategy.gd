@abstract
class_name TargetingStrategy extends Resource

@abstract
func get_targets(source: Unit, battle_manager: BattleManager) -> Array[Unit]

func get_weighted(source: Unit, candidates: Array[Unit], battle_manager: BattleManager) -> Array:
	var weighted_candidates = candidates.map(func (c: Unit): return [1.0, c])

	for status in source.status_effects:
		for buff in status.buffs:
			if buff.targeting_provider:
				buff.targeting_provider.modify_weights(weighted_candidates, battle_manager)
	return weighted_candidates

func pick_one(weighted_candidates: Array) -> Array[Unit]:
	if not weighted_candidates:
		return []
	var wheight_sum: float = weighted_candidates.map(func(c): return c[0]).reduce(func (a, b): return a+b, 0)
	var rand = randf_range(0.0, wheight_sum)

	for c in weighted_candidates:
		if rand <= c[0]:
			return [c[1]]
		else:
			rand -= c[0]

	return [weighted_candidates[0][1]] # fallback for rounding errors
