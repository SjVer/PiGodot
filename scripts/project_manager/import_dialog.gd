extends WindowDialog

const success_icon = preload("res://assets/icons/StatusSuccess.svg")
const error_icon = preload("res://assets/icons/StatusError.svg")

onready var status_icon : TextureRect = $Margin/VBox/HBox/Status/Icon
onready var status_label : Label = $Margin/VBox/StatusLabel
onready var confirm_button : Button = $Margin/VBox/Buttons/ConfirmButton
onready var cancel_button : Button = $Margin/VBox/Buttons/CancelButton

func set_success_status():
	status_icon.texture = success_icon
	status_label.text = ""
	confirm_button.disabled = false

func set_error_status(message: String):
	status_icon.texture = error_icon
	status_label.text = message
	confirm_button.disabled = true

func _ready():
	_on_folder_input_changed($Margin/VBox/HBox/FolderInput.text)

func _on_folder_input_changed(new_text: String):
	var dir := Directory.new()
	if new_text == "":
		set_error_status("")
	elif dir.open(new_text) != OK:
		set_error_status("Please select an existing folder.")
	elif not dir.file_exists("project.godot"):
		set_error_status("Please select a folder containing a project.godot file.")
	else:
		set_success_status()

func _on_cancel_pressed():
	queue_free()

func _on_confirm_pressed():
	var dir := Directory.new()
	assert(dir.open($Margin/VBox/HBox/FolderInput.text) == OK)

	# add to projects.cfg
	var cfg := ConfigFile.new()
	cfg.load(PiGodot.data_dir.plus_file("projects.cfg"))
	cfg.set_value(dir.get_current_dir(), "favorite", false)
	cfg.save(PiGodot.data_dir.plus_file("projects.cfg"))

	# open project
	Workspace.open_project(dir.get_current_dir())
	get_tree().change_scene("res://scenes/editor/editor.tscn")

