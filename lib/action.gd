extends Resource

class_name Action

@export var title: String
@export var description: String
@export var flavour_text: String

@export var targeting: TargetingStrategy
@export var effects: Array[ActionEffect]

@export var texture: Texture2D
@export var effect_scene: PackedScene
@export var source_animation: InteractionEvent.AnimationKind = InteractionEvent.AnimationKind.None


func produce_event(source: Unit) -> InteractionEvent:
	var ev := InteractionEvent.new()
	ev.source_animation = source_animation
	ev.source = source
	return ev

func apply(source: Unit, bm: BattleManager) -> Array[AbstractBattleEvent]:
	var interaction_event: InteractionEvent = produce_event(source)
	var action_events: Array[AbstractBattleEvent] = []

	var targets = targeting.get_targets(source, bm)
	if not targets:
		return []

	for effect: ActionEffect in effects:
		for target: Unit in targets:
			var event_effects = effect.apply(source, target, bm, self)
			for event_effect in event_effects:
				if event_effect is InteractionEvent.TargetEffect:
					interaction_event.target_effects.append(event_effect)
				else:
					action_events.append(event_effect)
	var result_events: Array[AbstractBattleEvent] = []
	if not interaction_event.target_effects.is_empty():
		result_events.append(interaction_event)
	result_events.append_array(action_events)

	return result_events
