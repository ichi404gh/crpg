@tool
extends Control

@onready var es_bar: ProgressBar = %EsBar
@onready var hp_bar: ProgressBar = %HpBar
@onready var label: Label = %Label

@export_range(0, 1000, 1)
var hp_max: int = 100:
	set(value):
		hp_max = value
		update_ui()

@export_range(0, 1000, 1)
var hp: int = 80:
	set(value):
		hp = value
		update_ui()

@export_range(0, 1000, 1)
var es_max: int = 20:
	set(value):
		es_max = value
		update_ui()

@export_range(0, 1000, 1)
var es: int = 5:
	set(value):
		es = value
		update_ui()

var _is_ready := false

func update_ui():
	if Engine.is_editor_hint() or _is_ready:
		hp_bar.max_value = float(hp_max)
		hp_bar.value = float(hp)
		es_bar.max_value = float(es_max)
		es_bar.value = float(es)

		var text = "%s/%s" % [hp, hp_max]
		if es != 0 or es_max != 0:
			text += " %s/%s" % [es, es_max]
		else:
			es_bar.max_value = 1
		label.text = text

func _ready():
	_is_ready = true
	update_ui()
