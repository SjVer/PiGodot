extends Panel

onready var left_dock_top : TabContainer = $Margin/VBox/Docks/LeftDock/TopTabs
onready var left_dock_bottom : TabContainer = $Margin/VBox/Docks/LeftDock/BottomTabs
onready var right_dock_top : TabContainer = $Margin/VBox/Docks/CenterRight/RightDock/TopTabs
onready var right_dock_bottom : TabContainer = $Margin/VBox/Docks/CenterRight/RightDock/BottomTabs

var scenetree_dock = preload("res://scenes/editor/scenetree.tscn").instance()
var filesystem_dock = preload("res://scenes/editor/filesystem.tscn").instance()
var inspector_dock = preload("res://scenes/editor/inspector.tscn").instance()
onready var scenes := $Margin/VBox/Docks/CenterRight/CenterDock/VBox/VSplit/Scenes

func load_default_layout():
	left_dock_top.add_child(scenetree_dock)
	left_dock_bottom.add_child(filesystem_dock)
	right_dock_top.add_child(inspector_dock)

	$Margin/VBox/Docks.split_offset = 80
	$Margin/VBox/Docks/CenterRight.split_offset = -200

func has_unsaved_changes():
	return true

func _ready():
	scenetree_dock.editor = self
	filesystem_dock.editor = self
	inspector_dock.editor = self
	scenes.editor = self

	# load layout stuff
	load_default_layout()

	# prepare viewport
	scenes.viewport.size.x = Workspace.project.get_value("display", "window/size/width")
	scenes.viewport.size.y = Workspace.project.get_value("display", "window/size/height")


