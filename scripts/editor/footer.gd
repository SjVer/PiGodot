extends PanelContainer

onready var editor := owner

onready var footer_vsplit := editor.get_node("Margin/VBox/Docks/CenterRight/CenterDock/VBox/VSplit") 
onready var footer_spacer := footer_vsplit.get_node("NoFooterSpacer")
onready var output_tab := preload("res://scenes/editor/output.tscn").instance()

onready var current_tab = footer_spacer

func add_footer_tab(tab: Control):
	var b := ToolButton.new()
	b.text = tab.name
	b.toggle_mode = true
	b.connect("toggled", self, "_on_footer_button_pressed", [tab])
	$HBox.add_child(b)

	footer_vsplit.add_child(tab)
	tab.hide()

func _on_footer_button_pressed(toggled: bool, tab: Control):
	if current_tab.get("given_height") != null:
		current_tab.given_height = -footer_vsplit.split_offset

	current_tab.hide()

	if toggled:
		current_tab = tab
		footer_vsplit.split_offset = -tab.given_height
	else:
		current_tab = footer_spacer
		footer_vsplit.split_offset = 0

	current_tab.show()

func _ready():
	add_footer_tab(output_tab)
