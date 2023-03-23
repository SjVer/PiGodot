extends Panel

func _ready():
	OS.set_window_title(PiGodot.app_name + " - Project Manager")
	var version_label = $Margin/Control/Titlebar/Version/Label
	version_label.text = "%s %s" % [PiGodot.app_name, PiGodot.version]
