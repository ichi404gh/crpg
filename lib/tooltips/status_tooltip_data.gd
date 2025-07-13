class_name StatusTooltipData
extends TooltipData

var status: Unit.AppliedStatusEffect

func get_effects_text():
	return status.status_effect._get_description() + "\n" + tr("status_effect.constant.expires_in").format({val=status.duration})

func get_flavour_text():
	return tr(status.status_effect.flavour)
