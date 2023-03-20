extends Control

var project_folder: String

onready var title_label : Label = $Margin/HBox/Info/TitleLabel
onready var path_label : Label = $Margin/HBox/Info/PathOptions/PathLabel
onready var fav_button : TextureButton = $Margin/HBox/Favourite/Button

func _ready():
	path_label.add_color_override("font_color", Color(1, 1, 1, 0.6))
	$Margin/HBox/Info/PathOptions/OpenButton.modulate = Color(1, 1, 1, 0.6)

func initialize(folder: String, name: String, favorite: bool):
	project_folder = folder
	path_label.text = folder
	title_label.text = name
	fav_button.pressed = favorite
	_on_favourite_toggled(favorite)

func _on_project_pressed():
	# TODO: always true
	if $Button.has_focus():
		Workspace.open_project(project_folder)
		get_tree().change_scene("res://scenes/editor/editor.tscn")

func _on_open_button_pressed():
	OS.shell_open("file://" + project_folder)

func _on_favourite_toggled(button_pressed: bool):
	if button_pressed:
		fav_button.modulate = Color(1, 1, 1, 1)
	else:
		fav_button.modulate = Color(1, 1, 1, 0.2)

func _on_delete_pressed():
	var dialog := ConfirmationDialog.new()
	dialog.dialog_text = "This will delete the project permanently!"
	add_child(dialog)
	dialog.popup_centered_minsize()
