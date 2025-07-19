class_name DealingDamageModificator
extends DamageModificator

@export var flat_bonus: int = 0
@export var multiplicative_bonus: float = 1.0
@export var additive_bonus: float = 0.0

func modify(damage: DamagePipeline):
	damage.flat_bonus += flat_bonus
	damage.additive_multiplier += additive_bonus
	damage.multiplicative_multiplier *= multiplicative_bonus
