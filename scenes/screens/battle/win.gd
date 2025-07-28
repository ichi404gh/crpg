extends PanelContainer

@onready var exit: Button = %Exit

signal accepted

func _ready() -> void:
	exit.pressed.connect(_on_exit)

func _on_exit():
	accepted.emit()
