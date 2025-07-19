extends Effect
class_name HealEffect

@export var amount_min: int = 1
@export var amount_max: int = 3

func apply(_source: Unit, target: Unit, battle_manager: BattleManager, action: Action = null):
	var amount = randi_range(amount_min, amount_max)
	var events = []

	var interaction_effect = InteractionEvent.TargetEffect.new()
	interaction_effect.animation = InteractionEvent.AnimationKind.None
	interaction_effect.fx = action.effect_scene
	interaction_effect.hp_change = amount
	interaction_effect.target = target
	events.append(interaction_effect)

	var healing_events = battle_manager.healing_manager.apply_healing(target, amount)
	events.append_array(healing_events)
	return events

func _get_description():
	return tr("action_effect.heal.description").format({"min": amount_min, "max": amount_max})
