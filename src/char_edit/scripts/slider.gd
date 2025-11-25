extends Label
signal change_morph(text,value)
@export var vertex_groups = PackedColorArray()

func _on_HSlider_value_changed(value):
	emit_signal("change_morph",text,value)
func set_slider(value):
	$HSlider.value = value
