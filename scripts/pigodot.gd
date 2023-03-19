extends Node

var app_name : String = ProjectSettings.get("application/config/name")
var internal_app_name := app_name.to_lower()

var version : String = "pigodot main [7f721a6]" # %%VERSION%%

var data_dir := OS.get_data_dir().plus_file(internal_app_name)