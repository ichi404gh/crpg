extends Node


@onready var active_screen: Node = %ActiveScreen
@onready var scene_transition_backdrop: ColorRect = %SceneTransitionBackdrop

const GLOBAL_MAP = preload("uid://5ngcub6ltfb6")
const GlobalMap = preload("uid://cdowv2uekoy0i")

const Battle = preload("uid://dv5rr6wkps7v2")
const BATTLE = preload("uid://c6vs1yn5jv11w")

var map: GlobalMap
var battle: Battle
var party_info: PartyInfo


func _ready() -> void:
	setup_party()
	map = GLOBAL_MAP.instantiate()
	active_screen.add_child(map)
	map.setup(party_info)
	map.selected.connect(on_select_location)


func on_select_location(loc_data: LocationData):
	await fade_out()

	battle = BATTLE.instantiate()
	active_screen.remove_child(map)
	active_screen.add_child(battle)

	battle.party_lost.connect(on_battle_end)
	battle.party_won.connect(on_battle_end)
	var encounter_context = EncounterContext.new()
	encounter_context.player_party = party_info.player_party
	encounter_context.waves = loc_data.enemy_waves
	battle.setup(encounter_context)
	await fade_in()

func on_battle_end():
	await fade_out()

	battle.queue_free()
	active_screen.add_child(map)

	await fade_in()


func fade_out():
	await create_tween().tween_property(scene_transition_backdrop, "color:a", 1.0, 0.3).finished

func fade_in():
	await create_tween().tween_property(scene_transition_backdrop, "color:a", 0.0, 0.3).finished


func setup_party():
	const MAGE = preload("uid://lvyhifn668b0")
	const RANGER = preload("uid://drgbuud2gjo44")
	const SPEARMAN = preload("uid://c0okd6frubd66")

	var spearman = SPEARMAN.instantiate()
	var ranger = RANGER.instantiate()
	var mage = MAGE.instantiate()
	party_info = PartyInfo.new()
	party_info.player_party = [
		spearman,
		ranger,
		mage,
	]

	const MINOR_HEALER_STAFF = preload("uid://dish68jfthflt")
	const RUSTY_SPEAR = preload("uid://b6hacu4c6jf8g")
	const RUSTY_SWORD = preload("uid://dnyf1gkcwv2dj")

	party_info.inventory = []
	spearman.set_gear_item(RUSTY_SPEAR, Item.Slot.Weapon)
	ranger.set_gear_item(RUSTY_SWORD, Item.Slot.Weapon)
	mage.set_gear_item(MINOR_HEALER_STAFF, Item.Slot.Weapon)
