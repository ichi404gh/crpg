class_name InnateOrderProvider

func get_orders():
	const PRESS_THE_ATTACK = preload("uid://cdpfdl3ibdh8i")

	const DEFENSIVE_ORDER = preload("uid://7ednjpffcbfl")
	const TARGET_WOUNDED = preload("uid://dfvhodnsufs8m")
	return [
		PRESS_THE_ATTACK,
		DEFENSIVE_ORDER,
		TARGET_WOUNDED,
	]
