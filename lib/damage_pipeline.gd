class_name DamagePipeline

var min_flat: int = 0
var max_flat: int = 0
var flat_bonus: int = 0
var additive_multiplier: float = 0.0
var multiplicative_multiplier: float = 1.0

var resolved: bool = false
var resolved_value: int


func resolve():
	if resolved:
		return

	var base := randi_range(min_flat, max_flat)
	var res: int = roundi((roundi(base * (1 + additive_multiplier)) + flat_bonus) * multiplicative_multiplier)

	resolved_value = maxi(res, 0)
	resolved = true
