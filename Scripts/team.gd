extends Sprite2D


func _ready():
	$Button.pressed.connect(_back)

func _back():
	var main_menu = load("res://Scenes/main_page.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_menu
