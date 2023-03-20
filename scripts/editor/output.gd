extends PanelContainer

var given_height := 100
onready var output_text : RichTextLabel = $VBox/OutputText

func _on_message(type, text: String):
	match type:
		Log.MessageType.EDITOR:
			output_text.push_color(theme.get("Editor/colors/font_color"))
			
		Log.MessageType.STDOUT:
			output_text.push_color(theme.get("Editor/colors/font_color"))

		Log.MessageType.WARNING:
			output_text.push_color(theme.get("Editor/colors/warning_color"))

		Log.MessageType.ERROR:
			output_text.push_color(theme.get("Editor/colors/error_color"))

	output_text.add_text(text)
	output_text.add_text("\n")
	
	output_text.pop()

func _ready():
	Log.connect("message", self, "_on_message")
	output_text.push_mono()

	# TEMPORARY
	Log.send_editor_message("editor")
	Log.send_stdout_message("stdout")
	Log.send_warning_message("warning")
	Log.send_error_message("error")
