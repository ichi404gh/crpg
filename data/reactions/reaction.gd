class_name Reaction
extends Resource

@export var effects: Array[ReactionEffect]
@export var trigger: TriggeredOn = TriggeredOn.DamageTaken

func apply(ctx: ReactionContext):
	var events = []
	for effect in effects:
		events.append_array(effect.apply(ctx))

	events.append_array(ctx.bm.status_effect_manager.decrement_uses_by_reaction(ctx.source, self))

	return events

enum TriggeredOn {
	DamageTaken,
}
