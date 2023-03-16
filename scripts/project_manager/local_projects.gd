extends VBoxContainer

func open_folder_handler(folder: String):
	OS.shell_open("file://" + folder)

func item_gui_input_handler(event: InputEvent, folder: String):
	if event is InputEventMouseButton and event.doubleclick:
		Workspace.open_project(folder)
		get_tree().change_scene("res://scenes/editor/editor.tscn")

func add_project_item(folder: String):
	var project := Project.new()
	assert(project.load(folder.plus_file("project.godot")) == OK)

	var item : Panel = preload("res://scenes/project_manager/project_item.tscn").instance()
	# TODO: fix this
	item.add_stylebox_override("panel", theme.get_stylebox("pressed", "Button").duplicate())

	var title_label : Label = item.get_node("HBox/Info/TitleLabel")
	var path_label : Label = item.get_node("HBox/Info/PathOptions/PathLabel")
	var path_button : ToolButton = item.get_node("HBox/Info/PathOptions/OpenButton")

	title_label.text = project.get_value("application", "config/name")
	path_label.text = folder

	path_label.add_color_override("font_color", Color(1, 1, 1, 0.6))
	path_button.modulate = Color(1, 1, 1, 0.6)

	item.connect("gui_input", self, "item_gui_input_handler", [folder])
	path_button.connect("pressed", self, "open_folder_handler", [folder])

	$ProjectList/Panel/Margin/VBox.add_child(item)

func _ready():
	# load the projects

	var cfg_file := OS.get_data_dir().plus_file("pigodot").plus_file("projects.cfg")
	var cfg := ConfigFile.new()

	if File.new().file_exists(cfg_file):
		assert(cfg.load(cfg_file) == OK)

	for project_folder in cfg.get_sections():
		add_project_item(project_folder)
