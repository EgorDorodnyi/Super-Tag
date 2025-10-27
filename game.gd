extends Node2D

#game timer reference
@onready var game_timer = $Timer
@onready var timer_label = $Timer/TimerLabel

#Reference to all player node in the scene
@onready var all_characters = [
	$Player,
	$"player 2",
	$"Player 3",
	$"Player 4",
]

# keeps track of who is currently it
var tagger: CharacterBody2D = null
#Duration of each round
var round_time := 120 #seconds
# Number of active players, which was set in the PlayerSelecr secene
var player_count := Global.player_count
# currently active players
var characters = []

# number of players will be in the game
func set_player_count(count):
	player_count = count


func _ready():
	#list of players
	characters = []
	for i in range(player_count):
		if all_characters[i]:
			characters.append(all_characters[i])
	#Hide unused player nodes
	for i in range(player_count, all_characters.size()):
		if all_characters[i]:
			all_characters[i].hide()
			all_characters[i].set_process(false)
			all_characters[i].set_physics_process(false)
	randomize()

	# Hide all tag icons
	for c in characters:
		c.set_as_tagger(false)

	# Pick a random tagger
	tagger = characters[randi() % characters.size()]
	tagger.set_as_tagger(true)
	
	#Setup and start the timer
	game_timer.wait_time = round_time
	game_timer.start()

func _process(_delta):
	# update the timer label every frame
	if game_timer.time_left>0:
		timer_label.text = str(int(game_timer.time_left)) + "s"
		timer_label.add_theme_font_size_override("font_size", 40)
		# turn the timer red in last seconds
		if game_timer.time_left <= 10:
			timer_label.add_theme_color_override("font_color", Color.RED)
		else:
			timer_label.add_theme_color_override("font_color", Color.BLACK)
	else:
		_game_over()

func _physics_process(_delta):
	if not tagger:
		return

	# Check collisions with other players
	for p in characters:
		if p == tagger:
			continue

		# Simple distance check
		if tagger.global_position.distance_to(p.global_position) < 20:
			_change_tagger(p)
			break

func _change_tagger(new_tagger):
	# Turn off old tagger icon
	tagger.set_as_tagger(false)
	
	# Update to new tagger
	tagger = new_tagger
	tagger.set_as_tagger(true)

func _game_over():
	#when time is up, switch to a game over screen depending on who was the tagger 
	match tagger.name:
		"Player":
			get_tree().change_scene_to_file("res://Scenes/gameover_Player1.tscn")
		"player 2":
			get_tree().change_scene_to_file("res://Scenes/gameover_Player2.tscn")
		"Player 3":
			get_tree().change_scene_to_file("res://Scenes/gameover_Player3.tscn")
		"Player 4":
			get_tree().change_scene_to_file("res://Scenes/gameover_Player4.tscn")
