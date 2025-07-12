class_name DamageManager

var bm: BattleManager
func _init(bm: BattleManager):
	self.bm = bm

func apply_damage(target: Unit, amount: int) -> Array[AbstractBattleEevnt]:
	var events: Array[AbstractBattleEevnt] = []
	target.hp -= amount
	print("damage ", amount)
	print("hp ",  target.hp)
	if target.hp <= 0:
		target.alive = false
		var event = UnitDeadEvent.new()
		event.who = target
		events.append(event)

	return events
