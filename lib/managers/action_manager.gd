class_name ActionManager

## how much bigger cooldowns on actions make it more desirable to select this action
## score *= COOLDOWN_SCORE_MULTIPLIER * action.cooldown
const COOLDOWN_SCORE_MULTIPLIER = 0.8



static func get_actions_selection_for_unit(unit: Unit) -> Array[ActionInstance]:
	var res: Array[ActionInstance] = []
	if unit.unit_data.action_set:
		for action in unit.unit_data.action_set.actions:
			res.append(ActionInstance.new(action, unit.cooldowns.get(action.key, 0)))
	return res


static func auto_select_actions(unit: Unit, bm: BattleManager):
	var unit_actions = get_actions_selection_for_unit(unit)
	var available_actions: Array[ScoredAction] = []

	for action in unit_actions:
		if not unit.cooldowns.has(action.action.key):
			var sa = ScoredAction.new()
			sa.action = action.action
			sa.score = 1.0
			available_actions.append(sa)

	for sa in available_actions:
		if sa.action.targeting.get_targets(unit, bm).size() == 0:
			# zero valid targets - should almost never to choose to use this action
			sa.score *= 0.05

		var disirability_score = sa.action.desirability_evaluator.evaluate(unit, bm) if sa.action.desirability_evaluator else 1.0
		sa.score *= disirability_score
		sa.score *= (sa.action.cooldown + 1) * COOLDOWN_SCORE_MULTIPLIER

	available_actions.sort_custom(func (a: ScoredAction, b: ScoredAction): return a.score > b.score) # sort by score descending
	print(available_actions)
	unit.selected_actions.clear()

	while true:
		var possible_actions = available_actions.filter(func(sa: ScoredAction): return can_add_action_to_unit(unit, sa.action))
		if not possible_actions:
			break
		var action = weighted_random_choice(possible_actions)
		unit.selected_actions.append(action)

	unit.selected_actions_changed.emit(unit.selected_actions)


static func can_add_action_to_unit(unit: Unit, action: Action) -> bool:
	if actions_combined_cost_for_unit(unit) + action.cost > unit.unit_data.action_points:
		return false
	if unit.cooldowns.has(action.key):
		return false
	if action.cooldown > 0 and unit.have_planned_action_with_key(action.key):
		return false
	if action.has_tag(OncePerRound) and unit.selected_actions.has(action):
		return false

	return true

static func actions_combined_cost_for_unit(unit: Unit):
	return unit.selected_actions.map(func(a: Action): return a.cost).reduce(func(a,b): return a+b, 0)

static func weighted_random_choice(actions: Array) -> Action:
	var total_weight := 0.0
	for item in actions:
		total_weight += item.score

	var r := randf() * total_weight
	var cumulative := 0.0

	for item in actions:
		cumulative += item.score
		if r <= cumulative:
			return item.action

	return actions[-1].action  # fallback

class ScoredAction:
	var action: Action
	var score: float = 1.0

	func _to_string() -> String:
		return "%s (%s)" % [action.title, score]

class ActionInstance:
	var action: Action
	var cooldown

	func _init(action: Action, cooldown: int = 0):
		self.action = action
		self.cooldown = cooldown
