class_name Reaction
extends Resource

@export var effects: Array[Effect]
@export var trigger: TriggeredOn = TriggeredOn.DamageTaken
@export var effects_target: EffectTarget = EffectTarget.TriggeredUnit

func apply(ctx: ReactionContext):
	var target
	match effects_target:
		EffectTarget.TriggeredUnit:
			target = ctx.source
		EffectTarget.Self:
			target = ctx.target


	for effect in effects:
		effect.apply(ctx.target, target, ctx.bm)


enum TriggeredOn {
	DamageTaken,
}

enum EffectTarget {
	TriggeredUnit,
	Self,
}
