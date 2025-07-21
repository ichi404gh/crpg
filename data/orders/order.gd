class_name Order
extends Resource


@export var title: String = ""
@export var description: String = ""
@export var texture: Texture2D

@export var modificator_provider: ModificatorProvider
@export var targeting_provider: TargetingProvider


func _to_string() -> String:
	return "Order[%s]" % title
