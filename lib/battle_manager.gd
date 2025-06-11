extends Node
class_name BattleManager

signal time_paused()
signal time_resumed()
signal time_updated(new_time: float)

var is_running: bool = true
var battle_time: float = 0.0



func _process(delta):
	if is_running:
		battle_time += delta
		emit_signal("time_updated", battle_time)

func pause():
	is_running = false
	emit_signal("time_paused")

func resume():
	is_running = true
	emit_signal("time_resumed")

func reset():
	battle_time = 0.0
	emit_signal("time_updated", battle_time)

func play_card(source: Unit, target: Unit, card: ActionCard):
	pass
