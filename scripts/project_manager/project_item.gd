extends Panel

var project_folder: String

onready var title_label : Label = $HBox/Info/TitleLabel
onready var path_label : Label = $HBox/Info/PathOptions/PathLabel

func _ready():
	path_label.add_color_override("font_color", Color(1, 1, 1, 0.6))
	$HBox/Info/PathOptions/OpenButton.modulate = Color(1, 1, 1, 0.6)

func initialize(folder: String, name: String):
	project_folder = folder
	$HBox/Info/PathOptions/PathLabel.text = folder
	$HBox/Info/TitleLabel.text = name

func _on_open_button_pressed():
	OS.shell_open("file://" + project_folder)
