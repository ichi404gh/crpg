class_name StatusTooltipData
extends TooltipData

var status: Status

func get_effects_text() -> String:
	var strs = [tr(status.description)]
	for buff in status.buffs:
		strs.append(buff._get_description())
		if buff.targeting_provider:
			strs.append("Affects targeting")
		#if buff.modificator_provider:
			#for mod in buff.modificator_provider.provides:
				#strs.append(mod)

	var duration = ""
	if status.duration:
		duration = tr("status_effect.constant.expires_in").format({val=status.duration})
	if status.uses:
		duration = tr("status_effect.constant.charges_n").format({val=status.uses})
	return "\n".join(strs) + "\n" + duration

func get_flavour_text():
	return tr(status.flavour)
