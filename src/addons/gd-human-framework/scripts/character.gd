@tool
extends CharacterBody3D
class_name HumanGeneratorCharacter

var appearance: Dictionary={}

@export var body_parts: Dictionary[String, bool] = {}

func _ready():
	take_on_clothes("body")
	take_on_clothes("eyes")

func generate_mesh(mesh_inst: MeshInstance3D, is_body: bool = false):
	reset_mesh(mesh_inst, is_body)
	var vertex_arr=mesh_inst.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
	for shape_name in appearance:
		var shp_indx = CharEditGlobal.meshs_shapes[mesh_inst.name]["shp_name_index"]
		if shp_indx.keys().has(shape_name):
			shp_indx = shp_indx[shape_name]
			vertex_arr = update_vertex(mesh_inst,vertex_arr,shp_indx,appearance[shape_name])
	save_mesh(mesh_inst,vertex_arr, is_body)

func generate_all_meshs():
	var time= Time.get_ticks_msec( )
	var meshs =$skeleton.get_children()
	for mesh_inst in meshs:
		generate_mesh(mesh_inst)
	print (Time.get_ticks_msec( )-time)
	
func reset_mesh(mesh_inst: MeshInstance3D, is_body: bool = false):
	save_mesh(mesh_inst,CharEditGlobal.meshs_shapes[mesh_inst.name]["base_form"], is_body)

func update_vertex(mesh_inst,vertex_arr,shp_indx,value):
	var blend = CharEditGlobal.meshs_shapes[mesh_inst.name]["blendshapes"][shp_indx]
	for i in range(len(vertex_arr)):
		vertex_arr[i] += blend[i]*value
	return vertex_arr

func save_mesh(mesh_inst: MeshInstance3D, vertex_arr, is_body: bool = false):
	var mat = mesh_inst.get_surface_override_material(0)
	var mesh_arrs = mesh_inst.mesh.surface_get_arrays(0)
	var blend_shape = null
	var shp_name_index: Dictionary = {}
	if is_body:
		blend_shape = mesh_inst.mesh.surface_get_blend_shape_arrays(0)
		for i in range(mesh_inst.mesh.get_blend_shape_count ()):
			shp_name_index[mesh_inst.mesh.get_blend_shape_name(i)] = i
	mesh_arrs[Mesh.ARRAY_VERTEX] = vertex_arr
	mesh_inst.mesh = ArrayMesh.new()
	if is_body:
		for i in range(shp_name_index.size()):
			mesh_inst.mesh.add_blend_shape(shp_name_index.keys()[i])
			mesh_inst.mesh.blend_shape_mode = Mesh.BLEND_SHAPE_MODE_NORMALIZED
		mesh_inst.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,mesh_arrs, blend_shape)
	else:
		mesh_inst.mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,mesh_arrs)
	mesh_inst.set_surface_override_material(0,mat)
	

func update_morph(shape_name,value):
	var temp = value;
	if appearance.has(shape_name):
		value -= appearance[shape_name]
	var meshs =$skeleton.get_children()
	for mesh_inst in meshs:
		var shp_indx = CharEditGlobal.meshs_shapes[mesh_inst.name]["shp_name_index"]
		if shp_indx.keys().has(shape_name):
			shp_indx = shp_indx[shape_name]
			var vertex_arr=mesh_inst.mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
			save_mesh(mesh_inst,update_vertex(mesh_inst,vertex_arr,shp_indx,value))
	appearance[shape_name] = temp
	if appearance[shape_name]==0:
		# Удалим ключ, если он нулевой. Это позволит не крутить лишний раз цикл при генерации персонажа для этой формы
		# Let's erase the key 0 to avoid unnecessary loop for the character.
		appearance.erase(shape_name)

func random_face_gen(intensity: float):
	for param in CharEditGlobal.meshs_shapes["forms"]["head"].keys():
		appearance [param] = randf()*intensity
	generate_all_meshs()
		
func take_off_clothes(cloth: String):
	var clothes = $skeleton.get_children()
	for i in clothes:
		if cloth == i.name:
			i.queue_free()

func take_on_clothes(cloth: String):
	var take_cloth = $skeleton.get_children()
	for i in take_cloth:
		# Проверка на то, что вещь уже одета. Иначе у нас снова будет такая же сцена, но её имя изменится, а у нас по имени загружается меш и тд. Короче, вылет.
		# If item is already equipped - you must stop doing this because of bug out risk.
		if cloth == i.name: 
			return
	take_cloth = load("res://addons/gd-human-framework/meshs/"+cloth+".tscn").instantiate()
	$skeleton.add_child(take_cloth)
	if Engine.is_editor_hint():
		take_cloth.owner = get_tree().edited_scene_root
	generate_mesh(take_cloth, cloth == "body")
