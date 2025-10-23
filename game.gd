extends Node2D

@onready var characters = [
	$Player,
	$"player 2",
	$"Player 3",
	$"Player 4",
]

@onready var game_timer = $Timer
@onready var timer_label = $Timer/TimerLabel

var tagger: CharacterBody2D = null
var round_time := 120 #seconds

func _ready():
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

func _process(delta):
	if game_timer.time_left>0:
		timer_label.text = str(int(game_timer.time_left)) + "s"
		timer_label.add_theme_font_size_override("font_size", 40)
	if game_timer.time_left <= 10:
		timer_label.add_theme_color_override("font_color", Color.RED)
	else:
		timer_label.add_theme_color_override("font_color", Color.BLACK)
func _physics_process(delta):
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
