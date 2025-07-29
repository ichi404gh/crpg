class_name ModifyDamageReactionEffect
extends ReactionEffect

@export var flat_bonus: int = 0
@export var additive_multiplier: float = 0.0

func apply(ctx: ReactionContext) -> Array[AbstractBattleEvent]:
	ctx.damage.flat_bonus += flat_bonus
	ctx.damage.additive_multiplier += additive_multiplier
	return []
