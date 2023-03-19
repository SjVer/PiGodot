extends Node

var app_name : String = ProjectSettings.get("application/config/name")
var internal_app_name := app_name.to_lower()

var version : String = "main [1972561]" # %%VERSION%%

var data_dir := OS.get_data_dir().plus_file(internal_app_name)