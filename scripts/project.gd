extends ConfigFile
class_name Project

var folder : String

func load(project_folder: String) -> int:
	folder = project_folder
	var path := folder.plus_file("project.godot")

	if not File.new().file_exists(path):
		printerr("[Workspace]: ERROR: project file not found: ", path)
		return ERR_FILE_NOT_FOUND
	else: 
		return .load(path)

func save_project() -> int:
	return .save(folder.plus_file("project.godot"))