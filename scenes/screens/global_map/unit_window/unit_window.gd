class_name UnitWindow
extends PanelContainer


signal closed


@onready var name_label: Label = %NameLabel
@onready var close_button: Button = %CloseButton
@onready var inventory_grid: GridContainer = %InventoryGrid

@onready var weapon_slot: ItemSlot = %WeaponSlot
@onready var armor_slot: ItemSlot = %ArmorSlot
@onready var accessory_slot: ItemSlot = %AccessorySlot


var unit: Unit
var party_info: PartyInfo
var dmr: DamageModificatorRegistry = DamageModificatorRegistry.new()


func _ready() -> void:
	close_button.pressed.connect(closed.emit)

func setup(unit: Unit, party_info: PartyInfo):
	self.unit = unit
	self.party_info = party_info
	name_label.text = unit.unit_name

	setup_modificators()
	setup_inventory()


func setup_modificators():
	var mods = dmr.get_dealing_mods_for_unit(self.unit)
	print(mods)


func setup_inventory():
	# party inventory
	for idx in inventory_grid.get_child_count():
		var slot: ItemSlot = inventory_grid.get_child(idx)
		slot.setup(party_info.inventory.get(idx) if idx < party_info.inventory.size() else null)
		slot.item_changed.connect(on_inventory_slot_item_changed.bind(idx))

	# unit's gear
	# FIXME
	weapon_slot.setup(unit.gear[Item.Slot.Weapon])
	weapon_slot.item_changed.connect(on_gear_slot_item_changed.bind(Item.Slot.Weapon))

	armor_slot.setup(unit.gear[Item.Slot.Armor])
	armor_slot.item_changed.connect(on_gear_slot_item_changed.bind(Item.Slot.Armor))

	accessory_slot.setup(unit.gear[Item.Slot.Accessory])
	accessory_slot.item_changed.connect(on_gear_slot_item_changed.bind(Item.Slot.Accessory))


func on_inventory_slot_item_changed(item: Item, slot_idx: int):
	if slot_idx >= party_info.inventory.size():
		party_info.inventory.resize(slot_idx+1)
	party_info.inventory.set(slot_idx, item)
	#print(party_info.inventory)

func on_gear_slot_item_changed(item:Item, slot_kind: Item.Slot):
	unit.set_gear_item(item, slot_kind)
