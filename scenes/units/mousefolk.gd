extends UnitBaseUI


signal hit_moment

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func attack():
	attack_animation()
	await hit_moment

func hurt():
	hurt_animation()

func die():
	die_animation()

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
	pass

func _on_attack_hit_moment():
	hit_moment.emit()
