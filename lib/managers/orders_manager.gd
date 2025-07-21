class_name OrdersManager

var bm: BattleManager

func _init(bm: BattleManager):
	self.bm = bm
#
var active_order: Order = null:
	set(value):
		if active_order != value:
			if active_order:
				if active_order.modificator_provider:
					bm.modificator_registry.unregister(active_order.modificator_provider)
				if active_order.targeting_provider:
					bm.targeting_registry.unregister(active_order.targeting_provider)
			if value:
				if value.modificator_provider:
					bm.modificator_registry.register(value.modificator_provider, bm.player_party)
				if value.targeting_provider:
					bm.targeting_registry.register(value.targeting_provider, bm.player_party)
		active_order = value



func get_orders() -> Array[Order]:
	var iop = InnateOrderProvider.new()
	var res: Array[Order] = []
	res.append_array(iop.get_orders())
	return res
