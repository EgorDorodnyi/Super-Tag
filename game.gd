

extends Node2D

@onready var characters = [
	$Player,
	$"player 2",
	$"Player 3",
]

var tagger: CharacterBody2D = null

func _ready():
	randomize()

	# Hide all tag icons
	for c in characters:
		c.set_as_tagger(false)

	# Pick a random tagger
	tagger = characters[randi() % characters.size()]
	tagger.set_as_tagger(true)

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
