extends Panel

func _ready():
	var version_label = $Margin/Control/Titlebar/Version/Label
	version_label.text = "%s %s" % [PiGodot.app_name, PiGodot.version]
