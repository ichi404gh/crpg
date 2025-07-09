class_name DamageOverTimeEffect
extends StatusEffect

@export var duration_rounds: int
@export var damage: int

func tick(target: Unit, battle_manager: BattleManager):
	pass
	# TODO apply damage without scene animation
