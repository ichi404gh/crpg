class_name InteractionEvent
extends AbstractBattleEvent

var source: Unit
var source_animation: AnimationKind
var source_fx: PackedScene
var target_effects: Array[TargetEffect]

func add_effects(te: Array[TargetEffect]):
	self.target_effects.append_array(te)

func _to_string() -> String:
	return "Interaction %s %s" % [source_animation, self.target_effects.map(func (e: TargetEffect): return e)]

class TargetEffect extends AbstractBattleEvent:
	var target: Unit
	var animation: AnimationKind
	var hp_change: int
	var fx: PackedScene

	func _to_string() -> String:
		return "hp_change: %s" % [hp_change]

enum AnimationKind {
	Attack,
	Interact,
	Hurt,
	None,
}
