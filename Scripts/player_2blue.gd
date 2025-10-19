extends CharacterBody2D
@onready var tag_icon = $TagIcon
@onready var tilemap=$"../TileMapLayer3"
@onready var animated_sprite = $AnimatedSprite2D


var is_tagger: bool=false
const SPEED = 150.0
const JUMP_VELOCITY = -370.0

var BOUNCE_VELOCITY = -770.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("player2_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction -1,0,1
	var direction = Input.get_axis("player2_move_left", "player2_move_right")
	#flip the sprite
	if direction>0:
		animated_sprite.flip_h = false
	elif direction<0:
		animated_sprite.flip_h =true
	#apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
		#Bounce check
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision:
			var collider := collision.get_collider()
			if collider == tilemap:
				velocity.y = BOUNCE_VELOCITY
				break

	
#Tag icon
#check if the tagger collide 
func _on_Area_body_entered(body):
	if is_tagger and body is CharacterBody2D:
		body.set_as_tagger(true)
		set_as_tagger(false)
func set_as_tagger(value: bool):
	is_tagger = value
	tag_icon.visible= value
