@tool
extends Node
class_name HumanImporter

@export var cloth_array: Array = []

func import_meshes():
	# This is generation of necessary arrays.
	var forms = load("res://addons/gd-human-framework/imported_mesh/char_edit_importer.tscn").instantiate()
	add_child(forms)
	forms.hide()
	forms = forms.forms
	
	var blndshp: Array = []
	var shp_name_index: Dictionary = {}
	var mesh_arrs = load("res://addons/gd-human-framework/imported_mesh/body.mesh")
	for i in range(mesh_arrs.get_blend_shape_count ()):
		shp_name_index[mesh_arrs.get_blend_shape_name(i)] = i
	var blends = mesh_arrs.surface_get_blend_shape_arrays(0)
	
	mesh_arrs = mesh_arrs.surface_get_arrays(0)
	
	var mesh: ArrayMesh = ArrayMesh.new()
	for i in range(shp_name_index.size()):
		mesh.add_blend_shape(shp_name_index.keys()[i])
		mesh.blend_shape_mode = Mesh.BLEND_SHAPE_MODE_NORMALIZED
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,mesh_arrs, blends)
	ResourceSaver.save(mesh,"res://addons/gd-human-framework/meshs/body.mesh",32)
	
	var base_form = mesh_arrs[Mesh.ARRAY_VERTEX]
	var vertex_UV = mesh_arrs[Mesh.ARRAY_TEX_UV]
	for i in range(len(blends)):
		var temp = blends[i][0]
		for j in range(len (base_form)):
			temp[j] -= base_form [j]
		blndshp.push_back(temp)
	# UV vertices should be in one group, or holes in mesh will appear.
	# на текстуре надо следить, чтобы одинаковые вершины на швах UV были в одной группе, иначе будет дырка в меше.
	var tex: Image = Image.load_from_file("res://addons/gd-human-framework/imported_mesh/vertex_groups.png") 
	var tex_size: Vector2i = tex.get_size()
	
	for i in forms["body"].keys():
		var index=shp_name_index[i]
		for j in range(len(blndshp[index])):
			if forms["body"][i]:
				var uv_coord =vertex_UV[j]*Vector2(tex_size)
				if not tex.get_pixel(uv_coord.x,uv_coord.y) in forms["body"][i]: #Тут мы применяем группы вершин по текстуре, чтобы форма носа не влияла на всё тело.
					blndshp[index][j]=Vector3.ZERO
	for i in forms["head"].keys():
		var index=shp_name_index[i]
		for j in range(len(blndshp[index])):
			if forms["head"][i]:
				var uv_coord =vertex_UV[j]*Vector2(tex_size)
				if not tex.get_pixel(uv_coord.x,uv_coord.y) in forms["head"][i]:
					blndshp[index][j]=Vector3.ZERO
	for i in forms["exp"].keys():
		var index=shp_name_index[i]
		for j in range(len(blndshp[index])):
			if forms["exp"][i]:
				var uv_coord =vertex_UV[j]*Vector2(tex_size)
				if not tex.get_pixel(uv_coord.x,uv_coord.y) in forms["exp"][i]:
					blndshp[index][j]=Vector3.ZERO
	
	var meshs_shapes: Dictionary[String, Dictionary]={}
	meshs_shapes["body"] = {}
	meshs_shapes["body"]["blendshapes"] = blndshp.duplicate()
	meshs_shapes["body"]["base_form"] = base_form
	meshs_shapes["body"]["shp_name_index"] = shp_name_index.duplicate()
	meshs_shapes["forms"] = forms
	print(len(meshs_shapes["body"]["base_form"]))
	for text in cloth_array:
		shp_name_index = {}
		blndshp = []
		mesh_arrs = load("res://addons/gd-human-framework/imported_mesh/"+text+".mesh")
		for i in range(mesh_arrs.get_blend_shape_count ()):
			shp_name_index[mesh_arrs.get_blend_shape_name(i)] = i
		blends = mesh_arrs.surface_get_blend_shape_arrays(0)
		mesh_arrs = mesh_arrs.surface_get_arrays(0)
		base_form= mesh_arrs[Mesh.ARRAY_VERTEX]
		mesh = ArrayMesh.new()
		mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES,mesh_arrs)
		ResourceSaver.save(mesh,"res://addons/gd-human-framework/meshs/"+text+".mesh",32)
		for i in range(len(blends)):
			var temp = blends[i][0]
			for j in range(len (base_form)):
				temp[j] -= base_form[j]
			blndshp.push_back(temp)
		meshs_shapes[text] ={}
		meshs_shapes[text]["blendshapes"] = blndshp.duplicate()
		meshs_shapes[text]["base_form"] = base_form
		meshs_shapes[text]["shp_name_index"] = shp_name_index.duplicate()
		print (text +": "+ str(len(meshs_shapes[text]["base_form"])))
	var file=FileAccess.open_compressed("res://addons/gd-human-framework/shapes.dat",FileAccess.WRITE)
	file.store_var(meshs_shapes)
	file.close()
