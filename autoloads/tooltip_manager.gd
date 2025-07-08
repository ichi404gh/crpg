extends Node

var action_tooltip_instance: Control = null

func show(data: TooltipData, origin: CanvasItem):
	if data is ActionTooltipData:
		const ACTION_TOOLTIP = preload("uid://dart6y5fjuscr")

		action_tooltip_instance = ACTION_TOOLTIP.instantiate()
		var anchor = find_ancor_for(origin)
		if not anchor:
			return

		action_tooltip_instance.set_anchors_preset(Control.PRESET_FULL_RECT)
		anchor.add_child(action_tooltip_instance)

		(action_tooltip_instance.get_node("%ActionLabel") as Label).text = data.action.title
		(action_tooltip_instance.get_node("%Image") as TextureRect).texture = data.action.texture
		(action_tooltip_instance.get_node("%Description") as RichTextLabel).text = "[i]Deal[/i] [b]tons[/b] of damage"


func hide():
	if action_tooltip_instance:
		action_tooltip_instance.queue_free()

func find_ancor_for(node: Node) -> Control:
	var current = node
	while current:
		if current is TooltipContext:
			return current.node as Control
		current = current.get_parent()
	return null
