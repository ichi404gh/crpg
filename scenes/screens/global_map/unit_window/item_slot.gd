class_name ItemSlot
extends Control

@onready var texture_rect: TextureRect = %TextureRect
@export var slot_flags: Dictionary[Item.Slot, bool]

var item: Item:
	get: return item
	set(new_item):
		if not can_place_item(item):
			return

		item = new_item
		item_changed.emit(item)


signal item_changed(item: Item)


func setup(item: Item):
	self.item = item

	if not item:
		texture_rect.texture = null
		return

	texture_rect.texture = self.item.texture

func can_place_item(item: Item):
	if not item:
		return true
	if slot_flags.is_empty():
		return true

	for flag in item.slot_mask:
		if item.slot_mask[flag]:
			if not slot_flags.get(flag, false):
				return false
	return true

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item:
		return null
	var data = DragData.new()
	data.setup(self)
	data.dropped_success.connect(on_item_dragged)

	set_drag_preview(data.preview)

	return data

func on_item_dragged(prev_slot):
	var this_slot_new_item = prev_slot.item
	var other_slot_new_item = item
	prev_slot.setup(other_slot_new_item)
	setup(this_slot_new_item)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var drag_data = data as DragData
	if not drag_data:
		return false

	return can_place_item(drag_data.slot.item)


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var drag_data = data as DragData
	drag_data.dropped(self)


class DragData:
	var preview: Control
	var slot: ItemSlot

	signal dropped_success(prev_slot: ItemSlot)

	func setup(slot: ItemSlot):
		self.slot = slot
		var texture = TextureRect.new()
		texture.texture = slot.item.texture
		texture.expand_mode = TextureRect.ExpandMode.EXPAND_FIT_WIDTH_PROPORTIONAL
		texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		texture.custom_minimum_size = Vector2(50, 50)

		preview = texture

	func dropped(prev_slot: ItemSlot):
		dropped_success.emit(prev_slot)
