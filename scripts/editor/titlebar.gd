extends HBoxContainer

onready var editor = owner

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

func _ready():
	for key in menu_options:
		var p : PopupMenu = $Left.get_node(key).get_popup()
		var first := true

		for opts in menu_options[key]:
			if first: first = false
			else: p.add_separator()

			for opt in opts:
				p.add_item(opt, opts[opt])

		p.set_hide_on_window_lose_focus(true)
		p.connect("id_pressed", self, "_on_menu_option_pressed")

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
			if not confirmed and owner.has_unsaved_changes():
				confirm(id, "Save changes before quitting?", "Save & Quit")
			else:
				print("[Editor]: quitting...")
				get_tree().quit(0)

		MenuOption.QUIT_TO_PROJECT_LIST:
			if not confirmed and editor.has_unsaved_changes():
				confirm(id, "Save changes before closing?", "Save & Close")
			else:
				get_tree().change_scene("res://scenes/project_manager/project_manager.tscn")

		MenuOption.RELOAD_PROJECT:
			Preferences.set_ui_scale(1.5)
			Preferences.save()
			PiGodot.restart()
			# if not confirmed and editor.has_unsaved_changes():
			# 	confirm(id, "Save changes before reloading?", "Save & Reload")
			# else:
			# 	get_tree().change_scene("res://scenes/editor/editor.tscn")

		MenuOption.ABOUT_PIGODOT:
			if $AboutPopup/Panel/Margin/Text.bbcode_text == "":
				var f := File.new()
				assert(f.open("res://misc/about.bb", File.READ) == OK)
				$AboutPopup/Panel/Margin/Text.bbcode_text = f.get_as_text()
				$AboutPopup/Panel/Margin/Text.connect("meta_clicked", OS, "shell_open")
				f.close()
			$AboutPopup.popup_centered()

		_: printerr("[Editor]: menu option not handled: ", id)
