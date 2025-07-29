class_name Order
extends Resource


@export var title: String = ""
@export var description: String = ""
@export var texture: Texture2D
@export var flavour_text: String

@export var modificator_provider: ModificatorProvider
@export var targeting_provider: TargetingProvider
@export var effects: Array[Effect]
@export var targeting: TargetingStrategy

func _to_string() -> String:
	return "Order[%s]" % title
