extends ActionEffect
class_name DamageEffect

@export var amount: int = 5

func apply(source, target):
	target.health -= amount
