class_name ReceivingDamageModificator
extends DamageModificator

@export var flat_bonus: int = 0
@export_range(0.1, 10.0, 0.1) var multiplicative_bonus: float = 1.0
@export_range(0.0, 1.0, 0.05) var additive_bonus: float = 0.0

func modify(damage: DamagePipeline):
	damage.flat_bonus += flat_bonus
	damage.additive_multiplier += additive_bonus
	damage.multiplicative_multiplier *= multiplicative_bonus
