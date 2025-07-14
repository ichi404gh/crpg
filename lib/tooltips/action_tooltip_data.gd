class_name ActionTooltipData
extends TooltipData

var action: Action

func get_flavour_text() -> String:
	return tr(action.flavour_text)

func get_effects_text() -> String:
	var strs = []
	for effect in action.effects:
		strs.append(effect._get_description())
	return "\n".join(strs)
