extends Effect
class_name DamageEffect

@export var amount_min: int = 1
@export var amount_max: int = 5

func apply(source: Unit, target: Unit, battle_manager: BattleManager, action: Action) -> Array[AbstractBattleEvent]:
	var events: Array[AbstractBattleEvent] = []

	var base_damage = randi_range(amount_min, amount_max)

	var damage_result = battle_manager.damage_mananger.apply_damage(source, target, base_damage)
	var interaction_effect = InteractionEvent.TargetEffect.new()
	interaction_effect.animation = InteractionEvent.AnimationKind.Hurt
	interaction_effect.fx = action.effect_scene
	interaction_effect.hp_change = -damage_result.final_damage
	interaction_effect.target = target
	events.append(interaction_effect)

	events.append_array(damage_result.events)
	return events

func _get_description():
	var ee = tr("action_effect.damage.description")
	return ee.format({"min":amount_min, "max":amount_max})
