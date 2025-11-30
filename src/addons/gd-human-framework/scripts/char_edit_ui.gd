extends Control

var forms: Dictionary = {}
var import: bool = false
var character: HumanGeneratorCharacter
var randomize_intensity: float = 0.5

var editor_visible: bool = false

func _ready():
	randomize()
	var Body_forms: Dictionary = {}
	var Head_forms: Dictionary = {}
	var Exp_forms: Dictionary = {}
	# connect all signals for all sliders
	var morphs=$morphs/Body/GridContainer.get_children()
	for i in morphs:
		#i.connect("change_morph", Callable(self, "change_morph"))
		Body_forms[i.text] = i.vertex_groups
	morphs=$morphs/Head/GridContainer.get_children()
	for i in morphs:
		#i.connect("change_morph", Callable(self, "change_morph"))
		Head_forms[i.text] = i.vertex_groups
	morphs=$morphs/Face/GridContainer.get_children()
	for i in morphs:
		#i.connect("change_morph", Callable(self, "change_morph"))
		Head_forms[i.text] = i.vertex_groups
	morphs=$morphs/Eyes/GridContainer.get_children()
	for i in morphs:
		#i.connect("change_morph", Callable(self, "change_morph"))
		Head_forms[i.text] = i.vertex_groups
	morphs=$morphs/Exp/GridContainer.get_children()
	for i in morphs:
		#i.connect("change_morph", Callable(self, "change_morph"))
		Exp_forms[i.text] = i.vertex_groups
	forms["body"] = Body_forms
	forms["head"] = Head_forms
	forms["exp"] = Exp_forms
	var path= OS.get_executable_path() # Здесь устанавливаем пути для открытия, сохранения файлов.
	if OS.get_name() == "Windows":
		path = path.substr(0,path.rfind("\\")+1)
	else:
		path = path.substr(0,path.rfind("/")+1)
	$save_file.current_dir = path
	$open_file.current_dir = path

func set_character(human):
	character = human
	$cam/spt.add_child(character)
	
func change_morph(text,value):
	character.update_morph(text,value)
	
func load_json (filepath: String):
	var file = FileAccess.open(filepath,FileAccess.READ)
	var test_json_conv: JSON = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var json = test_json_conv.get_data()
	file.close()
	return json

func save_json(filepath, value):
	var file=FileAccess.open(filepath,FileAccess.READ)
	file.store_line(JSON.stringify(value))
	file.close()

func _on_save_pressed():
	$save_file.popup()
	$save_file.invalidate()

func _on_open_pressed():
	$open_file.popup()
	$open_file.invalidate()

func _on_save_file_file_selected(path):
	save_json(path,character.appearance)

func _on_open_file_file_selected(path):
	character.appearance=load_json(path)
	reset_all_sliders(character.appearance)
	character.generate_all_meshs()

func reset_tab_slider(morphs, appearance):
	for sld in morphs:
		if appearance.has(sld.text):
			sld.set_slider(appearance[sld.text])
		else:
			sld.set_slider(0)

func reset_all_sliders(appearance):
	reset_tab_slider($morphs/Body/GridContainer.get_children(), appearance)
	reset_tab_slider($morphs/Head/GridContainer.get_children(), appearance)
	reset_tab_slider($morphs/Face/GridContainer.get_children(), appearance)
	reset_tab_slider($morphs/Eyes/GridContainer.get_children(), appearance)
	reset_tab_slider($morphs/Exp/GridContainer.get_children(), appearance)
	
func reset_character(chr):
	character=chr
	reset_all_sliders(character.appearance)

func _on_random_gen_pressed():
	character.random_face_gen(randomize_intensity)
	reset_tab_slider($morphs/Head/GridContainer.get_children(),character.appearance)
	reset_tab_slider($morphs/Face/GridContainer.get_children(),character.appearance)
	reset_tab_slider($morphs/Eyes/GridContainer.get_children(),character.appearance)
	
func _on_print_pressed():
	print(character.appearance)

func set_intensity(value):
	randomize_intensity = value

func _on_dress_mini_03_toggled(button_pressed):
	if button_pressed:
		character.take_on_clothes("dress_mini_03")
	else:
		character.take_off_clothes("dress_mini_03")

func _on_male_shirt_01_toggled(button_pressed):
	if button_pressed:
		character.take_on_clothes("male_shirt_01")
	else:
		character.take_off_clothes("male_shirt_01")

func _on_male_jeans_01_toggled(button_pressed):
	if button_pressed:
		character.take_on_clothes("male_jeans_01")
	else:
		character.take_off_clothes("male_jeans_01")
	
