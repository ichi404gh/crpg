@abstract class_name TargetingProvider extends Resource

@export_range(0.1, 5.0, 0.1) var weight: float = 1.0


func modify_weights(wheighted_candidates: Array, bm: BattleManager):
	for wheighted_candidate in wheighted_candidates: # [1.0, Unit]
		if matches(wheighted_candidate[1], bm):
			wheighted_candidate[0] *= weight


@abstract func matches(target: Unit, bm: BattleManager) -> bool
