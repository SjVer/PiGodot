extends VBoxContainer

var cfg_file := PiGodot.data_dir.plus_file("projects.cfg")
var cfg : ConfigFile

func add_project_item(folder: String, favorite: bool):
	var item = preload("res://scenes/project_manager/project_item.tscn").instance()
	$ProjectList/Panel/VBox.add_child(item)

	item.initialize(folder, favorite)
	item.connect("favorite_toggled", self, "_on_project_favorite_toggled", [folder])
	item.connect("project_deleted", self, "_on_project_deleted", [folder])

func _ready():
	# load projects file
	cfg = ConfigFile.new()
	if File.new().file_exists(cfg_file): assert(cfg.load(cfg_file) == OK)
	
	# load projects
	reload_projects()

func reload_projects():
	for child in $ProjectList/Panel/VBox.get_children(): child.queue_free()

	var favorites := []
	var others := []

	for project_folder in cfg.get_sections():
		if cfg.get_value(project_folder, "favorite", false):
			favorites.append(project_folder)
		else:
			others.append(project_folder)
	
	for project_folder in favorites: add_project_item(project_folder, true)
	for project_folder in others: add_project_item(project_folder, false)

func _on_project_favorite_toggled(is_favorite: bool, folder: String):
	cfg.set_value(folder, "favorite", is_favorite)
	cfg.save(cfg_file)
	reload_projects()

func _on_project_deleted(folder: String):
	# confirmation is handled by the item itself

	if Directory.new().dir_exists(folder):
		OS.move_to_trash(folder)
		
	cfg.erase_section(folder)
	cfg.save(cfg_file)
	reload_projects()

func _on_import_pressed():
	var dialog : WindowDialog = preload("res://scenes/project_manager/import_dialog.tscn").instance()
	add_child(dialog)
	dialog.popup_centered_minsize()
