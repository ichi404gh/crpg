extends UnitBaseUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

func attack():
	pass
func die():
	pass
func hurt():
	pass
func interact():
	pass

func _ready() -> void:
	area_2d.input_event.connect(_on_area_input)

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
