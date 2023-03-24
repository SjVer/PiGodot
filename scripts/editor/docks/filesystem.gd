extends VBoxContainer

const folder_modulate := Color("96b9ef")

const hidden_filetypes = ["import", "godot", ""]

const filetype_icons = {
	# "gd": preload("res://assets/icons/GDScript.svg"),
	# "tscn": preload("res://assets/icons/PackedScene.svg"),
	"bmp": preload("res://assets/icons/ImageTexture.svg"),
	"dds": preload("res://assets/icons/ImageTexture.svg"),
	"exr": preload("res://assets/icons/ImageTexture.svg"),
	"hdr": preload("res://assets/icons/ImageTexture.svg"),
	"jpg": preload("res://assets/icons/ImageTexture.svg"),
	"jpeg": preload("res://assets/icons/ImageTexture.svg"),
	"png": preload("res://assets/icons/ImageTexture.svg"),
	"svg": preload("res://assets/icons/ImageTexture.svg"),
	"tga": preload("res://assets/icons/ImageTexture.svg"),
	"webp": preload("res://assets/icons/ImageTexture.svg"),

	"wav": preload("res://assets/icons/AudioStreamWAV.svg"),
	"ogg": preload("res://assets/icons/AudioStreamOggVorbis.svg"),
	"mp3": preload("res://assets/icons/AudioStreamMP3.svg"),

	"scn": preload("res://assets/icons/PackedScene.svg"),
	"tscn": preload("res://assets/icons/PackedScene.svg"),
	"escn": preload("res://assets/icons/PackedScene.svg"),
	"dae": preload("res://assets/icons/PackedScene.svg"),
	"gltf": preload("res://assets/icons/PackedScene.svg"),
	"glb": preload("res://assets/icons/PackedScene.svg"),

	"gdshader": preload("res://assets/icons/Shader.svg"),
	"gdshaderinc": preload("res://assets/icons/TextFile.svg"),
	"gd": preload("res://assets/icons/GDScript.svg"),

	# "res": preload("res://assets/icons/Resource.svg"),
	# "tres": preload("res://assets/icons/Resource.svg"),
	"atlastex": preload("res://assets/icons/AtlasTexture.svg"),
	"obj": preload("res://assets/icons/Mesh.svg"),

	"txt": preload("res://assets/icons/TextFile.svg"),
	"md": preload("res://assets/icons/TextFile.svg"),
	"rst": preload("res://assets/icons/TextFile.svg"),
	"json": preload("res://assets/icons/TextFile.svg"),
	"yml": preload("res://assets/icons/TextFile.svg"),
	"yaml": preload("res://assets/icons/TextFile.svg"),
	"toml": preload("res://assets/icons/TextFile.svg"),
	"cfg": preload("res://assets/icons/TextFile.svg"),
	"ini": preload("res://assets/icons/TextFile.svg"),
}

var file_icon = preload("res://assets/icons/File.svg")
var folder_icon = preload("res://assets/icons/Folder.svg")

var editor

onready var search_input : LineEdit = $SearchBar/Input
onready var tree : Tree = $Tree

class FileItem:
	var file_name: String
	var full_path: String
	var icon: StreamTexture
	var modulate: Color
	var is_dir: bool
	var files: Array
	var directories: Array

	static func compare(a: FileItem, b: FileItem):
		return a.file_name < b.file_name

	func copy():
		var ret : FileItem = FileItem.new()
		ret.file_name = file_name
		ret.full_path = full_path
		ret.icon = icon
		ret.modulate = modulate
		ret.is_dir = is_dir
		ret.files = []
		ret.directories = []

		for f in files: ret.files.append(f.copy())
		for d in directories: ret.directories.append(d.copy())

		return ret

	func filter(query: String) -> bool:
		var found := false

		for f in files:
			if not (query in f.file_name):
				files.erase(f)
			else:
				found = true
		
		for d in directories:
			if not d.filter(query):
				directories.erase(d)
			else:
				found = true
			
		return found

var root_file_item: FileItem

func get_file_icon(filename: String):
	if filetype_icons.has(filename.get_extension()):
		return filetype_icons[filename.get_extension()]
	else:
		return file_icon

func scan_directory(dir: Directory, item: FileItem):
	assert(dir.list_dir_begin(true, true) == OK)

	var filename := "\b" # placeholder
	while filename != "":
		filename = dir.get_next()
		var path = dir.get_current_dir().plus_file(filename)

		# add the item
		var sub_item : FileItem = FileItem.new()
		sub_item.file_name = filename
		sub_item.full_path = Workspace.localize_path(path)
		sub_item.files = []
		sub_item.directories = []

		if dir.current_is_dir():
			# open subdirectory
			var sub_dir = Directory.new()
			sub_dir.open(dir.get_current_dir())
			assert(sub_dir.change_dir(filename) == OK)

			# check for .gdignore
			if sub_dir.file_exists(".gdignore"): continue

			# add item
			sub_item.icon = folder_icon
			sub_item.modulate = folder_modulate
			sub_item.is_dir = true

			# resurse in the directory
			scan_directory(sub_dir, sub_item)
			item.directories.append(sub_item)
		else:
			sub_item.is_dir = false
			sub_item.icon = get_file_icon(filename)

			# check for hidden file
			if hidden_filetypes.has(filename.get_extension()): continue
			item.files.append(sub_item)
	
	dir.list_dir_end()

func fill_file_tree(root: TreeItem, item: FileItem):
	# check for root item
	if root == null:
		tree.clear()
		item = item.copy()

	# set up the item
	var sub_item : TreeItem = tree.create_item(root)
	sub_item.set_text(0, item.file_name)
	sub_item.set_icon(0, item.icon)
	sub_item.set_meta("full_path", item.full_path)
	sub_item.set_tooltip(0, item.full_path)

	if item.modulate:
		sub_item.set_icon_modulate(0, item.modulate)

	sub_item.collapsed = item.is_dir and root != null and search_input.text == ""

	# sort items
	item.files.sort_custom(FileItem, "compare")
	item.directories.sort_custom(FileItem, "compare")
	
	# filter
	# TODO: doesn't work well for some reason
	if search_input.text != "":
		var _found = item.filter(search_input.text)

	# fill in the tree
	for file in item.directories: fill_file_tree(sub_item, file)
	for file in item.files: fill_file_tree(sub_item, file)

func update_file_tree():
	# reset the root file item
	root_file_item.files = []
	root_file_item.directories = []

	# scan the root directory
	var dir := Directory.new()
	assert(dir.open(Workspace.resource_dir) == OK)

	scan_directory(dir, root_file_item)

	# fill the tree
	fill_file_tree(null, root_file_item)

func _ready():
	name = "FileSystem"

	root_file_item = FileItem.new()
	root_file_item.file_name = "res://"
	root_file_item.icon = folder_icon
	root_file_item.modulate = folder_modulate
	root_file_item.is_dir = true

	update_file_tree()

	tree.connect("cell_selected", self, "_on_tree_item_selected")

func _on_search_input_changed(_new_text: String):
	fill_file_tree(null, root_file_item)

func _on_reload_pressed():
	update_file_tree()

func _on_tree_item_selected():
	var path : String = tree.get_selected().get_meta("full_path")
	var exts := ResourceLoader.get_recognized_extensions_for_type("PackedScene")

	if path.get_extension() in exts:
		editor.scenes.add_scene(Workspace.globalize_path(path))
