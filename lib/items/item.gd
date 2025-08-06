class_name Item
extends Resource

@export var texture: Texture2D
@export var slot_mask: Dictionary[Slot, bool]

@export var action_provider: ActionProvider
@export var mod_provider: ModificatorProvider

enum Slot {
	Weapon,
	Armor,
	Accessory,
}
