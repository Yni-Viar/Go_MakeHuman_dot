extends Node

func _ready():
	var temp =load("res://char_edit/char_edit_GUI.tscn").instantiate()
	add_child(temp)
	temp.set_character(load("res://char_edit/character.tscn").instantiate())
