class_name ActionManager


static func get_actions_selection_for_unit(unit: Unit) -> Array[ActionInstance]:
	const BLOOD_RAGE = preload("uid://dbeheok7fyhml")
	const QUANTUM_HEALING = preload("uid://bh8avx15y0r84")
	const RAISE_SHIELD = preload("uid://bdn4xdv5r32bi")
	const WEAPON_STRIKE = preload("uid://cf5ul8llmqy0c")
	const COUNTERATTACK = preload("uid://bwk7vs1anmvcn")

	var actions = [
		WEAPON_STRIKE,
		QUANTUM_HEALING,
		RAISE_SHIELD,
		BLOOD_RAGE,
		COUNTERATTACK
	]
	var res: Array[ActionInstance] = []
	for action in actions:
		res.append(ActionInstance.new(action, unit.cooldowns.get(action.key, 0)))
	return res

class ActionInstance:
	var action: Action
	var cooldown

	func _init(action: Action, cooldown: int = 0):
		self.action = action
		self.cooldown = cooldown


static func select_action_for_ai_unit(unit: Unit) -> Array[Action]:
	if not unit.ai_controlled:
		return []

	match unit.unit_data.ai_actions_presets.size():
		0:
			return []
		1:
			return unit.unit_data.ai_actions_presets[0].preset
		_:
			var weights_sum = unit.unit_data.ai_actions_presets\
				.map(func (p: ActionPreset): return p.weight)\
				.reduce(func(a,b): return a+b, 0)

			var rnd = randf() * weights_sum

			#var weights = unit.unit_data.ai_actions_presets.map(func (p: UnitData.ActionPreset): return p.weight)
			var comulative_weight := 0.0
			for preset: ActionPreset in unit.unit_data.ai_actions_presets:
				comulative_weight += preset.weight
				if rnd <= comulative_weight:
					return preset.preset
			return []
