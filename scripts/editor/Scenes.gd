extends Tabs

const text := preload("res://assets/icons/Node.svg")

func _enter_tree():
	pass

func _ready():
	add_tab("my test scene", text)
	add_tab("my test scene 2", text)
	add_tab("my test scene 3", text)
