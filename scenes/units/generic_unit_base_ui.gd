extends UnitBaseUI

@onready var click_area: Area2D = $ClickArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func attack():
	attack_animation()
	await hit_moment

func hurt():
	hurt_animation()

func die():
	die_animation()

func interact():
	pass

func finish_animations():
	if animation_player.current_animation != 'idle':
		await animation_player.current_animation_changed

func _on_attack_hit_moment():
	hit_moment.emit()

func _ready() -> void:
	click_area.input_event.connect(_on_area_input)
	click_area.mouse_entered.connect(_on_mouse_hover)
	click_area.mouse_exited.connect(_on_mouse_leave)


func _on_mouse_hover():
	self.hovered.emit(true)

func _on_mouse_leave():
	self.hovered.emit(false)

func _on_area_input(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and \
			event.pressed and \
			event.button_index == MOUSE_BUTTON_LEFT:
		self.clicked.emit()

func attack_animation():
	animation_player.stop()
	animation_player.clear_queue()
	animation_player.play("attack")
	animation_player.queue("idle")

func hurt_animation():
	animation_player.stop()
	animation_player.clear_queue()

	animation_player.play("hurt")
	animation_player.queue("idle")

func die_animation():
	animation_player.stop()
	animation_player.clear_queue()

	animation_player.play("die")
