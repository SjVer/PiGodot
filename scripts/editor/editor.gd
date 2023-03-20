extends Panel

onready var left_dock_top : TabContainer = $Margin/VBox/Docks/LeftDock/TopTabs
onready var left_dock_bottom : TabContainer = $Margin/VBox/Docks/LeftDock/BottomTabs
onready var right_dock_top : TabContainer = $Margin/VBox/Docks/CenterRight/RightDock/TopTabs
onready var right_dock_bottom : TabContainer = $Margin/VBox/Docks/CenterRight/RightDock/BottomTabs
onready var scene_tabs : Tabs = $Margin/VBox/Docks/CenterRight/CenterDock/VBox/Scenes/Tabbar/Tabs
onready var add_scene_button : ToolButton = $Margin/VBox/Docks/CenterRight/CenterDock/VBox/Scenes/Tabbar/Tabs/AddSceneButton

var scenetree_dock = preload("res://scenes/editor/scenetree.tscn").instance()
var filesystem_dock = preload("res://scenes/editor//filesystem.tscn").instance()
var inspector_dock = preload("res://scenes/editor//inspector.tscn").instance()

enum MenuOption {
	QUIT,
	QUIT_TO_PROJECT_LIST,
	RELOAD_PROJECT,
	ABOUT_PIGODOT,
}

const menu_options = {
	"SceneMenu": [
		{
			"Quit": MenuOption.QUIT,
		}
	],
	"ProjectMenu": [
		{
			"Reload Project": MenuOption.RELOAD_PROJECT,
			"Quit to Project List": MenuOption.QUIT_TO_PROJECT_LIST,
		}
	],
	"HelpMenu": [
		{
			"About PiGodot": MenuOption.ABOUT_PIGODOT,
		}
	]
}

func load_default_layout():
	left_dock_top.add_child(scenetree_dock)
	left_dock_bottom.add_child(filesystem_dock)
	right_dock_top.add_child(inspector_dock)

	$Margin/VBox/Docks.split_offset = 80
	$Margin/VBox/Docks/CenterRight.split_offset = -200

func update_tabs():
	# snap add button
	var last_rect := Rect2()
	if scene_tabs.get_tab_count() > 0:
		last_rect = scene_tabs.get_tab_rect(scene_tabs.get_tab_count() - 1)
	add_scene_button.rect_position.x = last_rect.position.x + last_rect.end.x + 3

func has_unsaved_changes():
	return true

func _ready():
	# add menu items
	var menus := $Margin/VBox/Titlebar/Left
	for key in menu_options:
		var p := (menus.get_node(key) as MenuButton).get_popup()
		var first := true
		for opts in menu_options[key]:
			if first: first = false
			else: p.add_separator()
			for opt in opts: p.add_item(opt, opts[opt])
		p.set_hide_on_window_lose_focus(true)
		p.connect("id_pressed", self, "_on_menu_option_pressed")

	# make add scene button darker
	add_scene_button.add_color_override("icon_color_normal",  Color(0.6, 0.6, 0.6, 0.8))

	# load layout stuff
	load_default_layout()

	# dummy scene
	scene_tabs.add_tab("test", preload("res://assets/icons/Node.svg"))
	update_tabs()

func confirm(id, message, ok = null, cancel = null):
	var dialog := ConfirmationDialog.new()
	dialog.dialog_text = message

	if ok: dialog.get_ok().text = ok
	if cancel: dialog.get_cancel().text = cancel

	dialog.get_ok().connect("pressed", self, "_on_menu_option_pressed", [id, true])

	add_child(dialog)
	dialog.popup_centered_minsize()

func _on_menu_option_pressed(id, confirmed: bool = false):
	match id:
		MenuOption.QUIT:
			if not confirmed and has_unsaved_changes():
				confirm(id, "Save changes before quitting?", "Save & Quit")
			else:
				print("[Editor]: quitting...")
				get_tree().quit(0)

		MenuOption.QUIT_TO_PROJECT_LIST:
			if not confirmed and has_unsaved_changes():
				confirm(id, "Save changes before closing?", "Save & Close")
			else:
				get_tree().change_scene("res://scenes/project_manager/project_manager.tscn")

		MenuOption.RELOAD_PROJECT:
			if not confirmed and has_unsaved_changes():
				confirm(id, "Save changes before reloading?", "Save & Reload")
			else:
				get_tree().change_scene("res://scenes/editor/editor.tscn")

		MenuOption.ABOUT_PIGODOT:
			if $AboutPopup/Panel/Margin/Text.bbcode_text == "":
				var f := File.new()
				assert(f.open("res://about.bb", File.READ) == OK)
				$AboutPopup/Panel/Margin/Text.bbcode_text = f.get_as_text()
				$AboutPopup/Panel/Margin/Text.connect("meta_clicked", OS, "shell_open")
				f.close()
			$AboutPopup.popup_centered()

		_: printerr("[Editor]: menu option not handled: ", id)
