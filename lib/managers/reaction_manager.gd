class_name ReactionManager

var bm: BattleManager

func _init(bm: BattleManager):
	self.bm = bm

func get_on_damage_taken_reaction_for_unit(unit: Unit) -> Array[Reaction]:
	var res: Array[Reaction]= []
	for status in unit.status_effects:
		for reaction in status.reactions:
			if reaction.trigger == Reaction.TriggeredOn.DamageTaken:
				res.append(reaction)

	return res
