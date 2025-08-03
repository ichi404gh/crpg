extends Node2D


const MapLocation = preload("uid://cr86u4fta5hxm")
const MAP_LOCATION = preload("uid://cslmcwir7anpu")
@onready var locations: Node2D = $CanvasLayer/Control/Locations

signal selected(location: LocationData)


const grid_columns = 3
const grid_rows = 5

var located_at: MapLocation


func _ready() -> void:
	generate_map()

func clicked_on(location: LocationData):
	selected.emit(location)

func generate_map():
	var locs = []
	const h_spacing = 70
	const v_spacing = 70
	for row in grid_rows:
		var location: MapLocation = MAP_LOCATION.instantiate()
		locations.add_child(location)
		location.position = Vector2(randi_range(0, grid_columns-1) * h_spacing + randf_range(-20, 20), - row * v_spacing + randf_range(-20, 20))
		var data = LocationData.new()
		data.label = "poop"
		data.enemy_waves.append(generate_waves())
		location.setup(data)
		location.clicked.connect(clicked_on)
		locs.append(location)

	const PATH = preload("uid://dyij74iutv25o")
	for idx in (locs.size() - 1):
		var line = PATH.instantiate()
		line.clear_points()
		line.add_point(locs[idx].position)
		line.add_point(locs[idx+1].position)
		locations.add_child(line)

func generate_waves() -> EnemyWave:
	const BAT = preload("uid://hwd0lxpta2ko")

	var res = EnemyWave.new()
	res.enemies.append(BAT.instantiate())
	res.enemies.append(BAT.instantiate())

	return res
