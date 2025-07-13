@abstract class_name StatusEffect
extends Resource

@export var title: String
@export var default_duration: int
@export var texture: Texture2D

@export var ticks_before_round: bool = false
@export var ticks_after_round: bool = false

func tick(_target: Unit, _bm: BattleManager) -> Array[AbstractBattleEvent]:
	return []
