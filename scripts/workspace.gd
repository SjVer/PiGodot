extends Node

var project: Project
var resource_dir: String
var userdata_dir: String

var resource_dir_regex : RegEx = RegEx.new()
var userdata_dir_regex : RegEx = RegEx.new()

func localize_path(path: String) -> String: 
	# adapted from https://github.com/godotengine/godot/blob/3.5/core/project_settings.cpp#L66

	if resource_dir.empty() or path.begins_with("res://") or path.begins_with("user://") \
	or (path.is_abs_path() && not path.begins_with(resource_dir)):
		return path.simplify_path()

	var dir := Directory.new()
	var dir_path := path.replace("\\", "/")

	if dir.change_dir(dir_path) == OK:
		# path is a directory

		# ensure trailing "/"
		var res_path := resource_dir.plus_file("");
		dir_path = dir_path.plus_file("");

		if not dir_path.begins_with(res_path): return path;
		else:
			var pos := dir_path.find(res_path)
			if pos >= 0:
				var begin := dir_path.substr(0, pos)
				var end := dir_path.substr(pos + res_path.length(), dir_path.length())
				return begin + "res://" + end 
			else: return dir_path
	else:
		# path might not exist or is file
		var sep := path.rfind("/")
		if sep == -1: return "res://" + path

		var parent := path.substr(0, sep)
		var plocal := localize_path(parent)

		if plocal == "": return ""
		else:
			if plocal[plocal.length() - 1] == "/": sep += 1
			return plocal + path.substr(sep, path.length() - sep)

func globalize_path(path: String) -> String:
	if path.begins_with("res://"):
		return resource_dir_regex.sub(path, resource_dir.plus_file(""))
		# if resource_dir != "": return path.replace("res:/", resource_dir)
		# else: return path.replace("res://", "")
	elif path.begins_with("user://"):
		return userdata_dir_regex.sub(path, userdata_dir.plus_file(""))
		# if userdata_dir != "": return path.replace("user:/", userdata_dir)
		# else: return path.replace("user://", "")
	else:
		return path
	
func open_project(folder: String):
	print("[Workspace]: opening project in folder: ", folder)
	resource_dir = folder

	# check project file
	var project_path := resource_dir.plus_file("project.godot")
	if not File.new().file_exists(project_path):
		printerr("[Workspace]: ERROR: project file not found: ", project_path)
		return

	# load project
	project = Project.new()
	assert(project.load(project_path) == OK)

	# find userdata dir
	var project_name = project.get_value("application", "config/name")
	userdata_dir = PiGodot.data_dir.plus_file(project_name).plus_file("")
	var dir := Directory.new()
	if not dir.dir_exists(userdata_dir):
		assert(dir.make_dir_recursive(userdata_dir) == OK)

	print("[Workspace]: user data dir is: ", userdata_dir)

func _init():
	resource_dir_regex.compile("^res://")
	userdata_dir_regex.compile("^user://")
