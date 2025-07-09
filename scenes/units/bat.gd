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
	pass

func _play_hurt_animation():
	animation_player.play("hurt")
	await animation_player.animation_finished
	animation_player.play("idle")

func _play_die_animation():
	animation_player.stop()
	animation_player.play("die")
