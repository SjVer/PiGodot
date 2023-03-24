extends VBoxContainer

var editor

func fill_tree(parent : TreeItem = null, node: Node = null):
	if node == null and editor.scenes.viewport.get_child_count() > 0:
		$Tree.clear()
		node = editor.scenes.viewport.get_child(0)
	elif node == null:
		return

	var item : TreeItem = $Tree.create_item(parent)
	item.set_text(0, node.name)
	item.set_icon(0, theme.get_icon(node.get_class(), "EditorIcons"))
	
	for child in node.get_children():
		fill_tree(item, child)

func _ready():
	name = "Scene"

func update():
	fill_tree()
