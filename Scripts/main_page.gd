extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button2.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	var player_select_scene = load("res://Scenes/PlayerSelect.tscn").instantiate()
	get_tree().root.add_child(player_select_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = player_select_scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
