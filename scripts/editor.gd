extends Panel

onready var left_dock_top : TabContainer = $Margin/VBox/Docks/LeftDock/TopTabs
onready var left_dock_bottom : TabContainer = $Margin/VBox/Docks/LeftDock/BottomTabs
onready var right_dock_top : TabContainer = $Margin/VBox/Docks/CenterRight/RightDock/TopTabs
onready var right_dock_bottom : TabContainer = $Margin/VBox/Docks/CenterRight/RightDock/BottomTabs
onready var scene_tabs : Tabs = $Margin/VBox/Docks/CenterRight/CenterDock/Scenes/Tabbar/Tabs
onready var add_scene_button : ToolButton = $Margin/VBox/Docks/CenterRight/CenterDock/Scenes/Tabbar/Tabs/AddSceneButton

var scenetree_dock = preload("res://scenes/scenetree.tscn").instance()
var filesystem_dock = preload("res://scenes/filesystem.tscn").instance()
var inspector_dock = preload("res://scenes/inspector.tscn").instance()

func load_default_layout():
	left_dock_top.add_child(scenetree_dock)
	left_dock_bottom.add_child(filesystem_dock)
	right_dock_top.add_child(inspector_dock)

	$Margin/VBox/Docks.split_offset = 80
	$Margin/VBox/Docks/CenterRight.split_offset = -200

func _ready():
	# make add scene button darker
	add_scene_button.add_color_override("icon_color_normal",  Color(0.6, 0.6, 0.6, 0.8))
	load_default_layout()

	# dummy scene
	scene_tabs.add_tab("test", preload("res://assets/icons/Node.svg"))
	update_tabs()

func update_tabs():
	# snap add button
	var last_rect := Rect2()
	if scene_tabs.get_tab_count() > 0:
		last_rect = scene_tabs.get_tab_rect(scene_tabs.get_tab_count() - 1)
	add_scene_button.rect_position.x = last_rect.position.x + last_rect.end.x + 3
