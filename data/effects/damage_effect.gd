extends Effect
class_name DamageEffect

@export var amount_min: int = 1
@export var amount_max: int = 5

func apply(source: Unit, target: Unit, battle_manager: BattleManager, action: Action = null) -> Array[AbstractBattleEvent]:
	var events: Array[AbstractBattleEvent] = []

	if not target:
		return events

	var damage = DamagePipeline.new()
	damage.min_flat = amount_min
	damage.max_flat = amount_max

	var damage_result = battle_manager.damage_mananger.apply_damage(source, target, damage)
	var interaction_effect = InteractionEvent.TargetEffect.new()
	interaction_effect.animation = InteractionEvent.AnimationKind.Hurt
	if action:
		interaction_effect.fx = action.effect_scene
	interaction_effect.hp_change = -damage_result.final_damage
	interaction_effect.target = target
	events.append(interaction_effect)

	events.append_array(damage_result.events)
	return events

func _get_description():
	var ee = tr("action_effect.damage.description")
	return ee.format({"min":amount_min, "max":amount_max})
