class_name DealingDamageModificator
extends DamageModificator

@export var flat_bonus: int = 0
@export var multiplicative_bonus: float = 1.0

func modify(value: int) -> int:
	return max(roundi(value * multiplicative_bonus) + flat_bonus, 0)
