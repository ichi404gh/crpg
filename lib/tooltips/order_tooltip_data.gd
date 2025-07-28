class_name OrderTooltipData
extends TooltipData

var order: Order

func _init(order: Order) -> void:
	self.order = order

func get_flavour_text():
	return tr(order.flavour_text)

func get_effects_text():
	var res = ""
	res += tr(order.description) + "\n"

	if order.modificator_provider:
		for mod in order.modificator_provider.provides:
			res += mod._get_description()
			if mod.mod_condition:
				res += " " + tr("modificator.constant.with_condition")  + " " + mod.mod_condition._get_description()
			res += "\n"
	if order.targeting_provider:
		res += "[val]{targeting}[/val]\n".format({"targeting": tr("buff.constant.affects_targeting")})
	return res
