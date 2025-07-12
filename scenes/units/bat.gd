extends UnitBaseUI

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func attack():
	pass

func die():
	await _play_die_animation()

func interact():
	pass

func hurt():
	await _play_hurt_animation()

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
