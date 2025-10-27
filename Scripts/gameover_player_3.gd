extends Sprite2D


func _ready():
	$Button2.pressed.connect(_restart)
	$Button.pressed.connect(_back_to_main)
	
func _restart():
	var game = load("res://Scenes/game.tscn").instantiate()
	get_tree().root.add_child(game)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = game

func _back_to_main():
	var menu = load("res://Scenes/main_page.tscn").instantiate()
	get_tree().root.add_child(menu)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = menu
