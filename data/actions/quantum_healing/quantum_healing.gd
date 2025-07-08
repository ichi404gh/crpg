extends ActionFX


@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func play_charge():
	pass

func play_impact():
	audio_stream_player.play()
	await get_tree().create_timer(0.3).timeout
	particles.emitting = false
	await get_tree().create_timer(0.5).timeout

	queue_free()
