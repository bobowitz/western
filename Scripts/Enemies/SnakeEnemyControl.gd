extends Node

var SPEED = 50.0
var HOSTILE_SPEED = 80.0
var STRIKE_RADIUS = 100
var STRIKE_SPEED = 300.0
var HOSTILE_FOLLOW_PLAYER_CHANCE = 0.75
var FOLLOW_RANDOM_CHANCE = 0.25
var direction = Vector2(0, 0)
var speed = SPEED
var hostile = false
var just_struck = false

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	get_parent().move(direction * speed * delta)
	
	if(not Rect2(Vector2(0, 0), WorldConstants.ROOM_SIZE).has_point(get_parent().get_pos() + get_parent().get_shape(0).get_extents())):
		direction *= -1
		get_parent().move(direction * speed * delta)
	elif(get_parent().is_colliding()):
		direction *= -1
		get_parent().move(direction * speed * delta)
		direction = direction.rotated(PI / 2)
	
	if(direction.x > 0):
		get_node("../Sprite").set_flip_h(true)
	if(direction.x < 0):
		get_node("../Sprite").set_flip_h(false)
	
	if(!hostile and (get_node("/root/Game/Player").get_node("Body").get_center() - get_parent().get_center()).length() < STRIKE_RADIUS):
		hostile = true
		direction = (get_node("/root/Game/Player").get_node("Body").get_center() - get_parent().get_center()).normalized()
		speed = STRIKE_SPEED
		get_node("../MoveTimer").set_wait_time(0.1)
		get_node("../MoveTimer").start()
		just_struck = true

func _on_move_timer_timeout():
	if(hostile):
		if(!just_struck and (get_node("/root/Game/Player").get_node("Body").get_center() - get_parent().get_center()).length() < STRIKE_RADIUS):
			direction = (get_node("/root/Game/Player").get_node("Body").get_center() - get_parent().get_center()).normalized()
			speed = STRIKE_SPEED
			get_node("../MoveTimer").set_wait_time(0.1)
			get_node("../MoveTimer").start()
			just_struck = true
		else:
			var r = randf()
			just_struck = false
			if(r < HOSTILE_FOLLOW_PLAYER_CHANCE):
				direction = (get_node("/root/Game/Player").get_node("Body").get_center() - get_parent().get_center()).normalized()
				speed = HOSTILE_SPEED
				get_node("../MoveTimer").set_wait_time(0.5)
				get_node("../MoveTimer").start()
			else:
				direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
				speed = HOSTILE_SPEED
				direction = direction.normalized()
				get_node("../MoveTimer").set_wait_time(0.5)
				get_node("../MoveTimer").start()
	if(!hostile):
		var r = randf()
		if(r < FOLLOW_RANDOM_CHANCE):
			just_struck = false
			direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
			speed = SPEED
			direction = direction.normalized()
			get_node("../MoveTimer").set_wait_time(1)
			get_node("../MoveTimer").start()
		else:
			just_struck = false
			direction = Vector2(0, 0)
			speed = SPEED
			get_node("../MoveTimer").set_wait_time(1)
			get_node("../MoveTimer").start()