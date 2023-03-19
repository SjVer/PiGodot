extends VBoxContainer

func add_project_item(folder: String):
	var project := Project.new()
	assert(project.load(folder.plus_file("project.godot")) == OK)

	var item : Panel = preload("res://scenes/project_manager/project_item.tscn").instance()
	item.initialize(folder, project.get_value("application", "config/name"))

	$ProjectList/Panel/Margin/VBox.add_child(item)

func _ready():
	# load the projects

	var cfg_file := OS.get_data_dir().plus_file("pigodot").plus_file("projects.cfg")
	var cfg := ConfigFile.new()

	if File.new().file_exists(cfg_file):
		assert(cfg.load(cfg_file) == OK)

	for project_folder in cfg.get_sections():
		add_project_item(project_folder)
