extends PanelContainer

signal clicked_retreat
signal clicked_next

@onready var retreat: Button = %Retreat
@onready var next: Button = %Next

func _ready() -> void:
	retreat.pressed.connect(_on_retreat)
	next.pressed.connect(_on_next)

func _on_retreat():
	clicked_retreat.emit()

func _on_next():
	clicked_next.emit()
