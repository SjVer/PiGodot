extends Node

var app_name : String = ProjectSettings.get("application/config/name")
var internal_app_name := app_name.to_lower()

var version_major: int = NAN
var version_minor: int = NAN
var version_patch: int = NAN
var version_hash: String
var version: String

var data_dir := OS.get_data_dir().plus_file(internal_app_name)

func _init():
	# load version
	var f := File.new()
	assert(f.open("res://version", File.READ) == OK)

	for line in f.get_as_text().split("\n"):
		var key = line.split("=")[0]
		var value = line.split("=")[1]
		match key:
			"MAJOR": version_major = value.to_int()
			"MINOR": version_minor = value.to_int()
			"PATCH": version_patch = value.to_int()
			"HASH": version_hash = value
			_: printerr("[PiGodot]: invalid version key: " + key) 
	
	if version_major == NAN: printerr("[PiGodot]: no major version found")
	if version_minor == NAN: printerr("[PiGodot]: no minor version found")
	if version_patch == NAN: printerr("[PiGodot]: no patch version found")
	if version_hash == "": printerr("[PiGodot]: no version hash found")

	version = "%d.%d.%d [%s]" % [
		version_major, version_minor, version_patch,
		version_hash
	]
