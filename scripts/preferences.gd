extends Node

var config := ConfigFile.new()

func save():
	config.save("user://preferences.cfg")

func set_ui_scale(scale: float):
	config.set_value("display", "window/stretch/shrink", scale)

func _init():
	if not File.new().file_exists("user://preferences.cfg") \
	and OS.get_name() in ["Android", "iOS"]:
		set_ui_scale(1.5)
		save()
		PiGodot.restart()

func _exit_tree():
	save()