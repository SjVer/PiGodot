extends VBoxContainer

func add_scene(_global_path: String):
	var vp := Viewport.new()
	vp.size = OS.get_screen_size()
	$Content/VBox/Preview/Viewports.rect_min_size = vp.size
	$Content/VBox/Preview/Viewports.rect_clip_content = true
	var child := Node2D.new()
	var sprite := Sprite.new()
	sprite.texture = preload("res://assets/icon.png")
	child.add_child(sprite)
	vp.add_child(child)
	$Content/VBox/Preview/Viewports.add_child(vp)
