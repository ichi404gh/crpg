class_name HealingManager

var bm: BattleManager
func _init(bm: BattleManager):
	self.bm = bm

func apply_healing(target: Unit, amount: int) -> Array[AbstractBattleEvent]:
	if target:
		target.hp = min(target.hp + amount, target.unit_data.max_hp)
	return []
