extends Node
class_name BattleManager

signal time_paused()
signal time_resumed()
signal time_updated(new_time: float)
signal card_activated(card: QueuedAction)
signal card_recovered(card: QueuedAction)
signal card_played(card: QueuedAction)

signal units_updated(pp: Array[Unit], ep: Array[Unit])


var is_running: bool = true
var battle_time: float = 0.0

var actions: Array[QueuedAction] = []
var player_party: Array[Unit] = []
var enemy_party: Array[Unit] = []


func _process(delta: float):
	if is_running:
		battle_time += delta
		emit_signal("time_updated", battle_time)
		_process_actions(delta)

func pause():
	is_running = false
	emit_signal("time_paused")
	print_debug("paused")
	

func resume():
	is_running = true
	emit_signal("time_resumed")
	print_debug("resumed")

func reset():
	battle_time = 0.0
	emit_signal("time_updated", battle_time)

func play_card(source: Unit, target: Unit, card: ActionCard):
	var qa = QueuedAction.new()
	qa.action = card
	qa.prepare = card.prepare_time
	qa.recovery = card.recover_time + card.prepare_time
	qa.source = source
	qa.target = target
	
	actions.append(qa)
	card_played.emit(qa)
	

func _process_actions(delta: float):

	for action in actions:
		if !action.done:
			if action.prepare <= 0:
				card_activated.emit(action)
				action.done = true
		action.prepare -= delta
			
		if !action.recovered:
			if action.recovery <= 0:
				card_recovered.emit(action)
				# remove from actions array?
				action.recovered = true
		action.recovery -= delta
		
func set_parties(player: Array[Unit], enemy: Array[Unit]):
	player_party = player
	enemy_party = enemy
	units_updated.emit(player, enemy)
