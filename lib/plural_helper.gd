class_name PluralHelper
extends Node

static func plural(prefix: String, number: int):
	var n = abs(number) % 100
	if n >= 11 and n <= 19:
		return TranslationServer.translate(prefix + ".many")
	n = n % 10
	if n == 1:
		return TranslationServer.translate(prefix + ".one")
	elif n >= 2 and n <= 4:
		return TranslationServer.translate(prefix + ".few")
	else:
		return TranslationServer.translate(prefix + ".many")
