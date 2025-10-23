extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.pressed.connect(_on_2players_pressed)
	$Button2.pressed.connect(_on_3players_pressed)
	$Button3.pressed.connect(_on_4players_pressed)

func _on_2players_pressed():
	_start_game(2)

func _on_3players_pressed():
	_start_game(3)
	
func _on_4players_pressed():
	_start_game(4)
	
func _start_game(player_count:int):
	var main_scene = load("res://Scenes/game.tscn").instantiate()
	main_scene.set_player_count(player_count)
	get_tree().root.add_child(main_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_scene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
