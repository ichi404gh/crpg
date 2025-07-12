extends ActionEffect
class_name DamageEffect

@export var amount_min: int = 1
@export var amount_max: int = 5

func apply(_source: Unit, target: Unit, battle_manager: BattleManager, action: Action) -> Array[AbstractBattleEvent]:
	var events: Array[AbstractBattleEvent] = []

	var damage = randi_range(amount_min, amount_max)


	var interaction_effect = InteractionEvent.TargetEffect.new()
	interaction_effect.animation = InteractionEvent.AnimationKind.Hurt
	interaction_effect.fx = action.effect_scene
	interaction_effect.hp_change = -damage
	interaction_effect.target = target
	events.append(interaction_effect)

	var damage_events = battle_manager.damage_mananger.apply_damage(target, damage)
	events.append_array(damage_events)
	return events
