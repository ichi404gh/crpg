extends UnitBaseUI


@onready var click_area: Area2D = $ClickArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	click_area.input_event.connect(_on_area_input)
	#click_area.mouse_entered.connect(_on_mouse_hover)
	#click_area.mouse_exited.connect(_on_mouse_leave)


#func _on_mouse_hover():
	#battle_manager.meta.hovered_unit = self.unit
#
#func _on_mouse_leave():
	#battle_manager.meta.hovered_unit = null

func _on_area_input(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and \
			event.pressed and \
			event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit()
		get_tree().get_root().set_input_as_handled()

func attack():
	attack_animation()
	await hit_moment

func hurt():
	hurt_animation()

func die():
	die_animation()

func finish_animations():
	if animation_player.current_animation != 'idle':
		await animation_player.animation_finished

func interact():
	pass

func attack_animation():
	animation_player.stop()
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("idle")

func hurt_animation():
	animation_player.stop()
	animation_player.play("hurt")
	await animation_player.animation_finished
	animation_player.play("idle")

func die_animation():
	animation_player.stop()
	animation_player.play("die")
	await animation_player.animation_finished


func _on_attack_hit_moment():
	hit_moment.emit()
