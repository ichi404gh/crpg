extends UnitBaseUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

func attack():
	attack_animation()
	await hit_moment

func die():
	await die_animation()

func hurt():
	await hurt_animation()

func interact():
	pass

func _ready() -> void:
	area_2d.input_event.connect(_on_area_input)
	area_2d.mouse_entered.connect(_on_mouse_hover)
	area_2d.mouse_exited.connect(_on_mouse_leave)

func _on_mouse_hover():
	self.hovered.emit(true)

func _on_mouse_leave():
	self.hovered.emit(false)

func _on_area_input(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and \
			event.pressed and \
			event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit()
		get_tree().get_root().set_input_as_handled()

func finish_animations():
	if animation_player.current_animation != 'idle':
		await animation_player.current_animation_changed

func _on_attack_hit_moment():
	hit_moment.emit()

func attack_animation():
	animation_player.stop()
	animation_player.play("attack")
	await animation_player.current_animation_changed
	animation_player.play("idle")

func hurt_animation():
	animation_player.stop()
	animation_player.play("hurt")
	await animation_player.current_animation_changed
	animation_player.play("idle")

func die_animation():
	animation_player.stop()
	animation_player.play("die")
	await animation_player.current_animation_changed
