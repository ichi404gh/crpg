class_name DamageIndicator
extends Node2D


@onready var label: Label = %Label
@onready var gpu_particles_2d_3: GPUParticles2D = %GPUParticles2D3


func setup(value: int):
	label.text = str(value)
	gpu_particles_2d_3.emitting = true
	gpu_particles_2d_3.one_shot = true
	await get_tree().create_timer(1).timeout
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0, 0.3)
	await t.finished
	queue_free()
