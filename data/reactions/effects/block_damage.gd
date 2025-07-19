class_name BlockDamageReactionEffect
extends ReactionEffect

func apply(ctx: ReactionContext) -> Array[AbstractBattleEvent]:
	ctx.damage.resolved = true
	ctx.damage.resolved_value = 0
	return []
