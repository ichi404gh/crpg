class_name ApplyEffect
extends ReactionEffect

@export var effects: Array[Effect]
@export var effects_target: EffectTarget = EffectTarget.TriggeredUnit


func apply(ctx: ReactionContext) -> Array[AbstractBattleEvent]:
	var events: Array[AbstractBattleEvent] = []
	var target
	match effects_target:
		EffectTarget.TriggeredUnit:
			target = ctx.target
		EffectTarget.Self:
			target = ctx.source


	for effect in effects:
		events.append_array(effect.apply(ctx.source, target, ctx.bm))

	return events


enum EffectTarget {
	TriggeredUnit,
	Self,
}
