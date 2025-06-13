extends Node
class_name BattleManager

signal time_paused()
signal time_resumed()
signal time_updated(new_time: float)
signal card_activated(card: QueuedAction)
signal card_recovered(card: QueuedAction)
signal card_played(card: QueuedAction)

signal unit_damaged(unit: Unit)
signal unit_died(unit: Unit)

signal units_updated(pp: Array[Unit], ep: Array[Unit])
signal battle_ended(winner: String) # "player" or "enemy"


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
	

func resume():
	is_running = true
	emit_signal("time_resumed")

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
		if !action.source.alive:
			continue
			
		if !action.done:
			if action.prepare <= 0:
				card_activated.emit(action)
				process_action_effects(action)
				action.done = true
		action.prepare -= delta
			
		if !action.recovered:
			if action.recovery <= 0:
				card_recovered.emit(action)
				# remove from actions array?
				action.recovered = true
		action.recovery -= delta

func process_action_effects(action: QueuedAction) -> void:
	for effect in action.action.effects:
		effect.apply(action.source, action.target, self)
			
func apply_damage(target: Unit, amount: int):
	target.hp -= min(amount, target.hp)
	unit_damaged.emit(target)

	if target.hp <= 0:
		target.alive = false
		unit_died.emit(target)
		on_unit_died()

func on_unit_died():
	if player_party.all(func (u): return !u.alive):
		battle_ended.emit("enemy")
		pause()
		print("enemy party wins")
	elif enemy_party.all(func (u): return !u.alive):
		battle_ended.emit("player")
		pause()
		print("player party wins")


func set_parties(player: Array[Unit], enemy: Array[Unit]):
	player_party = player
	enemy_party = enemy
	units_updated.emit(player, enemy)


func get_valid_targets(card: ActionCard, caster: Unit) -> TargetQueryResult:
	if caster in player_party:
		match card.target_type:
			"enemy":
				return TargetQueryResult.new(true, enemy_party)
			_:
				return TargetQueryResult.new(false)
	else:
		return TargetQueryResult.new(true, player_party)


class TargetQueryResult:
	var have_targets: bool
	var targets: Array[Unit]
	
	func _init(have_targets: bool, targets: Array[Unit] = []) -> void:
		self.have_targets = have_targets
		self.targets = targets
