extends Control


func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

func on_mouse_entered():
	var tween = create_tween()
	await tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.05).finished


func on_mouse_exited():
	var tween = create_tween()
	await tween.tween_property(self, "scale", Vector2(1, 1), 0.05).finished
