extends Node

enum MessageType {
	EDITOR,
	STDOUT,
	WARNING,
	ERROR,
}

signal message(type, text)
signal editor_message(text)
signal stdout_message(text)
signal warning_message(text)
signal error_message(text)

func output_message(type, text: String):
	match type:
		MessageType.EDITOR: print(text)
		MessageType.STDOUT: print(text)
		MessageType.WARNING: print(text)
		MessageType.ERROR: printerr(text)

func send_message(type, text: String):
	output_message(type, text)
	emit_signal("message", type, text)

func send_editor_message(text: String):
	send_message(MessageType.EDITOR, text)
	emit_signal("editor_message", text)

func send_stdout_message(text: String):
	send_message(MessageType.STDOUT, text)
	emit_signal("stdout_message", text)

func send_warning_message(text: String):
	send_message(MessageType.WARNING, text)
	emit_signal("warning_message", text)

func send_error_message(text: String):
	send_message(MessageType.ERROR, text)
	emit_signal("error_message", text)