extends VBoxContainer

func add_project_item(folder: String, favorite: bool):
	var project := Project.new()
	assert(project.load(folder.plus_file("project.godot")) == OK)
	var name = project.get_value("application", "config/name")

	var item = preload("res://scenes/project_manager/project_item.tscn").instance()
	$ProjectList/Panel/VBox.add_child(item)
	item.initialize(folder, name, favorite)

func _ready():
	# load the projects

	var cfg_file := OS.get_data_dir().plus_file("pigodot").plus_file("projects.cfg")
	var cfg := ConfigFile.new()

	if File.new().file_exists(cfg_file):
		assert(cfg.load(cfg_file) == OK)

	for project_folder in cfg.get_sections():
		var favorite = cfg.get_value(project_folder, "favorite", false)
		add_project_item(project_folder, favorite)
