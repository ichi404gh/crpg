class_name Reaction
extends Resource

@export var effects: Array[ReactionEffect]
@export var trigger: TriggeredOn = TriggeredOn.DamageTaken
#@export var effects_target: EffectTarget = EffectTarget.TriggeredUnit

func apply(ctx: ReactionContext):
	var events = []
	for effect in effects:
		events.append_array(effect.apply(ctx))

	return events

enum TriggeredOn {
	DamageTaken,
}
