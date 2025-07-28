class_name Reaction
extends Resource

@export var effects: Array[ReactionEffect]
@export var trigger: TriggeredOn = TriggeredOn.DamageTaken

func apply(ctx: ReactionContext):
	var events = []
	events.append_array(ctx.bm.status_effect_manager.decrement_uses_by_reaction(ctx.source, self))

	for effect in effects:
		events.append_array(effect.apply(ctx))


	return events

enum TriggeredOn {
	DamageTaken,
}
