@tool
extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_toggled(toggled_on: bool) -> void:
	get_parent().get_parent().get_parent().get_parent().get_parent().call("set_item", get_node("Button").text, toggled_on)
