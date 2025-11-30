extends Node

func _ready():
	var temp =load("res://addons/gd-human-framework/char_edit_ui.tscn").instantiate()
	add_child(temp)
	temp.set_character(load("res://addons/gd-human-framework/technical/character.tscn").instantiate())
