class_name Unit
extends Resource


@export var hp: int
@export var max_es: int
@export var es: int

@export var unit_name: String
@export var alive: bool = true
@export var unit_data: UnitData
@export var auto_selects_actions: bool = true
@export var gear: Dictionary[Item.Slot, Item] = {
	Item.Slot.Weapon: null,
	Item.Slot.Armor: null,
	Item.Slot.Accessory: null,
}

signal selected_actions_changed(actions: Array[Action])


var status_effects: Array[Status]
var unit_view: UnitBaseUI
var selected_actions: Array[Action] = []
var cooldowns: Dictionary[String, int] = {}

var gear_bonus_max_hp: int = 0
var gear_bonus_max_es: int = 0
var total_max_hp: int:
	get:
		return unit_data.max_hp + gear_bonus_max_hp

var total_max_es: int:
	get:
		return gear_bonus_max_es

func set_gear_item(item: Item, slot: Item.Slot):
	if gear[slot]: # if slot was occupied
		if gear[slot].action_provider:
			ActionRegistry.unregister(gear[slot].action_provider)
		if gear[slot].mod_provider:
			ModificatorRegistry.unregister(gear[slot].mod_provider)
		recalculate_gear_stat_bonuses()
	gear[slot] = item
	if item:
		if item.action_provider:
			ActionRegistry.register(item.action_provider, [self])
		if item.mod_provider:
			ModificatorRegistry.register(item.mod_provider, [self])
		recalculate_gear_stat_bonuses()

func recalculate_gear_stat_bonuses():
	gear_bonus_max_es = 0
	gear_bonus_max_hp = 0
	for item: Item in gear.values():
		if item:
			gear_bonus_max_es += item.stat_bonus_provider.get(Stat.MaxEs, 0)
			gear_bonus_max_hp += item.stat_bonus_provider.get(Stat.MaxHp, 0)
	if hp > total_max_hp:
		hp = total_max_hp

	print("total: hp: %s, es: %s" % [total_max_hp, total_max_es])

func remove_actions(index: int):
	selected_actions.remove_at(index)
	selected_actions_changed.emit(selected_actions)

func add_action(action: Action):
	if not ActionManager.can_add_action_to_unit(self, action):
		return
	selected_actions.append(action)
	selected_actions_changed.emit(selected_actions)

func have_planned_action_with_key(key: String):
	for a in selected_actions:
		if a.key == key:
			return true
	return false

func clear_cooling_down_actions():
	var old_size = selected_actions.size()
	selected_actions = selected_actions.filter(func(a: Action): return not cooldowns.has(a.key))
	if selected_actions.size() != old_size:
		selected_actions_changed.emit(selected_actions)


func tick_cooldowns():
	for key in cooldowns:
		cooldowns[key] -= 1
		if cooldowns[key] <= 0:
			cooldowns.erase(key)


func _to_string() -> String:
	return "%s, (%s)" % [unit_name, hp]

static func is_alive(unit: Unit) -> bool:
	return unit.alive

func instantiate_ui():
	if not unit_data:
		return

	unit_view = unit_data.unit_ui.instantiate() as UnitBaseUI
	return unit_view

func have_status(status: Status) -> bool:
	return find_applied_status(status) != null

func find_applied_status(status: Status) -> Status:
	for unit_status in self.status_effects:
		if unit_status.title == status.title: # FIXME
			return unit_status
	return null

func regenerate_es() -> int:
	var es_regen: int = min(1, round(total_max_es * 0.25))
	es = min(total_max_es, es + es_regen)
	return es_regen

enum Stat {
	MaxHp,
	MaxEs,
}
