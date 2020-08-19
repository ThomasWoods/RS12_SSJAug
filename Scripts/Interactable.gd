extends Node

var is_interactable:bool = true
signal interacted_with

func interact():
	emit_signal("interacted_with")
