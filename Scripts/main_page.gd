extends Sprite2D


func _ready():
	# Connect the buttons to their respective functions
	# Button2 starts the game (goes to player selection)
	# Button opens the credits screen
	$Button2.pressed.connect(_on_start_pressed)
	$Button.pressed.connect(_credit)
	
func _on_start_pressed():
	# Load the Player Select scene
	var player_select_scene = load("res://Scenes/PlayerSelect.tscn").instantiate()
	# Add it to the scene tree
	get_tree().root.add_child(player_select_scene)
	# Remove the current menu scene
	get_tree().current_scene.queue_free()
	# Set the player select scene as the active one
	get_tree().current_scene = player_select_scene

func _credit():
	# Load the team/credits scene
	var credit_scene = load("res://Scenes/team.tscn").instantiate()
	# Add it to the scene tree
	get_tree().root.add_child(credit_scene)
	# Remove the current menu scene
	get_tree().current_scene.queue_free()
	# Set the credits scene as the active one
	get_tree().current_scene = credit_scene
