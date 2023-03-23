extends Control

var project : Project

onready var project_icon : TextureRect = $Margin/HBox/Icon
onready var title_label : Label = $Margin/HBox/Info/TitleLabel
onready var title_input : LineEdit = $Margin/HBox/Info/TitleInput
onready var path_label : Label = $Margin/HBox/Info/PathOptions/PathLabel
onready var fav_button : TextureButton = $Margin/HBox/Favorite/Button

signal favorite_toggled(is_favorite)
signal project_deleted

func _ready():
	path_label.add_color_override("font_color", Color(1, 1, 1, 0.6))
	$Margin/HBox/Info/PathOptions/OpenButton.modulate = Color(1, 1, 1, 0.6)

func initialize(folder: String, favorite: bool):
	project = Project.new()
	if project.load(folder) == OK:
		title_label.text = project.get_value("application", "config/name")
		var icon_path = project.get_value("application", "config/icon")

		# globalize and load icon
		var image := Image.new()
		var regex : RegEx = RegEx.new()
		regex.compile("^res://")
		image.load(regex.sub(icon_path, folder.plus_file("")))
		image.resize(64, 64, Image.INTERPOLATE_LANCZOS)
		project_icon.texture = ImageTexture.new()
		project_icon.texture.create_from_image(image)
	else:
		# project is missing
		title_label.text = "Missing Project"
		project_icon.modulate = Color(1, 1, 1, 0.5)	
		$Margin/HBox/Info/PathOptions/OpenButton.icon = preload("res://assets/icons/FileBroken.svg")

	path_label.text = folder
	fav_button.pressed = favorite
	_on_favorite_toggled(favorite)

func _on_project_pressed():
	# TODO: always true
	if $Button.has_focus():
		Workspace.open_project(project.folder)
		get_tree().change_scene("res://scenes/editor/editor.tscn")

func _on_open_button_pressed():
	OS.shell_open("file://" + project.folder)

func _on_favorite_toggled(button_pressed: bool):
	if button_pressed:
		fav_button.modulate = Color(1, 1, 1, 1)
	else:
		fav_button.modulate = Color(1, 1, 1, 0.2)

	emit_signal("favorite_toggled", button_pressed)
	
func _on_rename_pressed():
	title_label.hide()
	title_input.text = title_label.text
	title_input.show()
	title_input.grab_focus()
	title_input.caret_position = title_input.text.length()

func _on_title_entered(new_text: String):
	project.set_value("application", "config/name", new_text)
	assert(project.save_project() == OK)

	title_input.hide()
	title_label.text = new_text
	title_label.show()

func _on_delete_pressed():
	var dialog := ConfirmationDialog.new()
	dialog.dialog_text = "This will move the project to the recycle bin or delete it permanently!"
	add_child(dialog)
	dialog.popup_centered_minsize()
	dialog.get_cancel().grab_focus()
	dialog.connect("confirmed", self, "emit_signal", ["project_deleted"])

