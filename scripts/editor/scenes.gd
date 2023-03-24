extends VBoxContainer

onready var tabs : Tabs = $Tabbar/Tabs
onready var add_scene_button : ToolButton = $Tabbar/Tabs/AddSceneButton
onready var viewport : Viewport = $Content/VBox/Preview/ViewportContainer/Viewport
var editor

func add_scene(_global_path: String):
	var child := Node2D.new()
	var sprite := Sprite.new()
	sprite.texture = preload("res://assets/default_icon.png")
	child.add_child(sprite)
	viewport.add_child(child)

	tabs.add_tab(
		child.name,
		theme.get_icon(child.get_class(), "EditorIcons")
	)
	update_tabs()
	editor.scenetree_dock.update()

func update_tabs():
	# snap add button
	var last_rect := Rect2()
	if tabs.get_tab_count() > 0:
		last_rect = tabs.get_tab_rect(tabs.get_tab_count() - 1)
	add_scene_button.rect_position.x = last_rect.position.x + last_rect.end.x + 3

func _ready():
	# make add scene button darker
	add_scene_button.add_color_override("icon_color_normal",  Color(0.6, 0.6, 0.6, 0.8))

func _draw():
	if viewport.get_child_count() > 0:
		viewport.get_child(0).draw_line(Vector2.ONE, Vector2.RIGHT * 10, Color.green)
