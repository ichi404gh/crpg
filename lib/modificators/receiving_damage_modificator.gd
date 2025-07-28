class_name ReceivingDamageModificator
extends DamageModificator

const base_multiplicative = 1.0
const base_additive =  0.0

@export var flat_bonus: int = 0
@export_range(0.1, 10.0, 0.1) var multiplicative_bonus: float = base_multiplicative
@export_range(0.0, 1.0, 0.05) var additive_bonus: float = base_additive

func modify(damage: DamagePipeline):
	damage.flat_bonus += flat_bonus
	damage.additive_multiplier += additive_bonus
	damage.multiplicative_multiplier *= multiplicative_bonus

func _get_description() -> String:
	var res = "%s: " % tr("modificator.dealing_damage.mod_desc")

	var componenets = []
	if flat_bonus != 0:
		componenets.append("[val]%+d[/val]" % flat_bonus)
	if additive_bonus != base_additive:
		componenets.append("[val]%+d%%[/val]" % (additive_bonus * 100))
	if multiplicative_bonus != base_multiplicative:
		componenets.append("[val]×%d%%[/val]" % (multiplicative_bonus * 100))
	if componenets:
		return res + ", ".join(componenets)
	return ""
