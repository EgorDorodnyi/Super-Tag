extends Sprite2D


func _ready():
	#connect buttons to functions
	$Button.pressed.connect(_restart)
	$Button2.pressed.connect(_back_to_main)
	
func _restart():
	# Reloads the main game scene
	var game = load("res://Scenes/game.tscn").instantiate()
	# Add the new gmae scene to the root
	get_tree().root.add_child(game)
	# Remove the current scene
	get_tree().current_scene.queue_free()
	# Set the new scene as the current one
	get_tree().current_scene = game

func _back_to_main():
	# Loads the main menu
	var menu = load("res://Scenes/main_page.tscn").instantiate()
	# Add it to the root
	get_tree().root.add_child(menu)
	# Remove the current scene
	get_tree().current_scene.queue_free()
	# Set the new scene as the current one
	get_tree().current_scene = menu
	
