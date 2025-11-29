@tool
extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for key in CharEditGlobal.cloth_array.keys():
		var item = load("res://addons/gd-human-framework/scripts/editor/clothes_item.tscn").instantiate()
		match CharEditGlobal.cloth_array[key]:
			"bodyparts":
				$VBoxContainer/BodyParts/ScrollContainer/VBoxContainer.add_child(item)
				item.get_node("Button").text = key
			"clothes":
				$VBoxContainer/Clothes/ScrollContainer/VBoxContainer.add_child(item)
				item.get_node("Button").text = key

func set_item(item: String, value: bool):
	if value:
		get_tree().edited_scene_root.get_child(0).take_on_clothes(item)
	else:
		get_tree().edited_scene_root.get_child(0).take_off_clothes(item)

func _on_clothes_select_close_requested() -> void:
	if !Engine.is_editor_hint():
		get_parent().queue_free()
