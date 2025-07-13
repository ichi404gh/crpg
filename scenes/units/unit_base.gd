@abstract
class_name UnitBaseUI
extends Node2D

@warning_ignore("unused_signal")
signal hit_moment

@warning_ignore("unused_signal")
signal clicked

@warning_ignore("unused_signal")
signal hovered(value: bool)

@abstract
func attack()

@abstract
func hurt()

@abstract
func die()

@abstract
func interact()

@abstract
func finish_animations()
