@tool
extends Label

@export var vertex_groups = PackedColorArray()

func set_slider(value):
	$HSlider.value = value


func _on_h_slider_value_changed(value: float) -> void:
	get_parent().get_parent().get_parent().get_parent().change_morph(text, value)
