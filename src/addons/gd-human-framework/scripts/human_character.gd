@tool
extends Node3D
class_name HumanCharacter

var character: HumanGeneratorCharacter

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		character = load("res://addons/gd-human-framework/technical/character.tscn").instantiate()
		add_child(character)
		CharEditGlobal.clothes_button.show()

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		CharEditGlobal.clothes_button.hide()
		character.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
