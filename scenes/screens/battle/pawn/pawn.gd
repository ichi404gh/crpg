extends Node2D
class_name Pawn

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ui: Node2D = $UI

signal hit_moment
signal clicked
signal hovering(unit: Unit)
signal stop_hovering(unit: Unit)

var battle_manager: BattleManager

var flipped = false
var unit: Unit



func _ready() -> void:
	sprite_2d.flip_h = flipped
	$Area2D.input_event.connect(_on_area_input)
	$Area2D.mouse_entered.connect(_on_mouse_hover)
	$Area2D.mouse_exited.connect(_on_mouse_leave)
	_on_selected_actions_changed(self.unit.selected_actions)

func _process(_delta: float) -> void:
	sprite_2d.set_instance_shader_parameter("outline", battle_manager.meta.hovered_unit == self.unit)

func _on_mouse_hover():
	battle_manager.meta.hovered_unit = self.unit

func _on_mouse_leave():
	battle_manager.meta.hovered_unit = null

func _on_area_input(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and \
			event.pressed and \
			event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)
		get_tree().get_root().set_input_as_handled()

func attack():
	_play_atack_animation()
	await hit_moment

func _play_atack_animation():
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("idle")

func hurt():
	_play_hurt_animation()

func _play_hurt_animation():
	print("hurt")
	animation_player.play("hurt")
	await animation_player.animation_finished
	animation_player.play("idle")


func _on_attack_hit_moment():
	hit_moment.emit()


func setup(_unit: Unit, _battle_manager: BattleManager):
	self.unit = _unit
	self.battle_manager = _battle_manager
	self.unit.selected_actions_changed.connect(_on_selected_actions_changed)


func _on_selected_actions_changed(actions: Array[Action]):
	const PREPARED_ACTION_UI = preload("uid://cjad02w8v2per")

	for c in ui.get_children():
		c.queue_free()
	var actions_count = 0
	for action in actions:
		if action == null:
			continue

		var action_ui = PREPARED_ACTION_UI.instantiate()
		action_ui.action = action
		action_ui.position.y = -32 * actions_count
		ui.add_child(action_ui)

		actions_count += 1

func flip():
	flipped = true
