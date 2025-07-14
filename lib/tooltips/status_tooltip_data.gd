class_name StatusTooltipData
extends TooltipData

var status: Status

func get_effects_text():
	var strs = []
	for buff in status.buffs:
		strs.append(buff._get_description())

	return "\n".join(strs) + "\n" + tr("status_effect.constant.expires_in").format({val=status.duration})

func get_flavour_text():
	return tr(status.flavour)
