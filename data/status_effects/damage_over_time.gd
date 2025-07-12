class_name DamageOverTimeEffect
extends StatusEffect

@export var damage: int


func tick(target: Unit, battle_manager: BattleManager):
	battle_manager.damage_mananger.apply_damage(target, damage)
