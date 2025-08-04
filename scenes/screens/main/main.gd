extends Node


@onready var active_screen: Node = %ActiveScreen
@onready var scene_transition_backdrop: ColorRect = %SceneTransitionBackdrop

const GLOBAL_MAP = preload("uid://5ngcub6ltfb6")
const GlobalMap = preload("uid://cdowv2uekoy0i")

const Battle = preload("uid://dv5rr6wkps7v2")
const BATTLE = preload("uid://c6vs1yn5jv11w")

var map: GlobalMap
var battle: Battle
var player_party: Array[Unit]


func _ready() -> void:
	setup_party()
	map = GLOBAL_MAP.instantiate()
	active_screen.add_child(map)
	map.setup(player_party)
	map.selected.connect(on_select_location)


func on_select_location(loc_data: LocationData):
	await fade_out()

	battle = BATTLE.instantiate()
	active_screen.remove_child(map)
	active_screen.add_child(battle)

	battle.party_lost.connect(on_battle_end)
	battle.party_won.connect(on_battle_end)
	var encounter_context = EncounterContext.new()
	encounter_context.player_party = player_party
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

	player_party = [
		SPEARMAN.instantiate(),
		RANGER.instantiate(),
		MAGE.instantiate(),
	]
