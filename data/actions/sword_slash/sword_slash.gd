extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	animated_sprite_2d.play()
	audio_stream_player.play()
	await animated_sprite_2d.animation_finished
	queue_free()
