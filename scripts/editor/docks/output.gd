extends PanelContainer

var given_height := 100
onready var output_text : RichTextLabel = $VBox/OutputText

func _on_message(type, text: String):
	match type:
		Log.MessageType.EDITOR:
			var color = theme.get("Editor/colors/font_color")
			output_text.push_color(color * Color(1, 1, 1, 0.6))
			
		Log.MessageType.STDOUT:
			output_text.push_color(theme.get("Editor/colors/font_color"))

		Log.MessageType.WARNING:
			output_text.add_image(preload("res://assets/icons/Warning.svg"))
			output_text.add_text(" ")
			output_text.push_color(theme.get("Editor/colors/warning_color"))

		Log.MessageType.ERROR:
			output_text.add_image(preload("res://assets/icons/Error.svg"))
			output_text.add_text(" ")
			output_text.push_color(theme.get("Editor/colors/error_color"))

	output_text.add_text(text)
	output_text.add_text("\n")
	
	output_text.pop()

func _ready():
	Log.connect("message", self, "_on_message")

func _on_clear_pressed():
	output_text.clear()

func _on_copy_pressed():
	var text := output_text.get_selected_text()
	if text == "": text = output_text.get_text()
	if text != "": OS.set_clipboard(text)
