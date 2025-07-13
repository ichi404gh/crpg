extends UnitBaseUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

func attack():
	pass

func die():
	await _play_die_animation()

func interact():
	pass

func hurt():
	await _play_hurt_animation()

func _ready() -> void:
	area_2d.input_event.connect(_on_area_input)
	area_2d.mouse_entered.connect(_on_mouse_hover)
	area_2d.mouse_exited.connect(_on_mouse_leave)

func _on_area_input(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and \
			event.pressed and \
			event.button_index == MOUSE_BUTTON_LEFT:
		self.clicked.emit()
		get_tree().get_root().set_input_as_handled()

func _on_mouse_hover():
	self.hovered.emit(true)

func _on_mouse_leave():
	self.hovered.emit(false)


func finish_animations():
	if animation_player.current_animation != 'idle':
		await animation_player.current_animation_changed


func _play_hurt_animation():
	animation_player.stop()
	animation_player.clear_queue()
	animation_player.play("hurt")
	animation_player.queue("idle")
	await animation_player.current_animation_changed


func _play_die_animation():
	animation_player.stop()
	animation_player.clear_queue()
	animation_player.play("die")
	await animation_player.current_animation_changed
