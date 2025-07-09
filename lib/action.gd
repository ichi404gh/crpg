extends Resource

class_name Action

@export var title: String
@export var effects: Array[ActionEffect]
@export var texture: Texture2D
@export var effect_scene: PackedScene
@export var source_animation: InteractionEvent.AnimationKind = InteractionEvent.AnimationKind.None


func produce_event(source: Unit) -> InteractionEvent:
	var ev := InteractionEvent.new()
	ev.source_animation = source_animation
	ev.source = source
	return ev
