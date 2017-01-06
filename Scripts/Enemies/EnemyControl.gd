extends Node

var SPEED = 50.0
var direction = Vector2(0, 0)

func _ready():
	direction = Vector2(0, 1)
	
	set_process(true)

func _process(delta):
	get_parent().move(direction * SPEED * delta)
	
	if(!WorldConstants.ENEMY_AREA.has_point(get_parent().get_pos())):
		direction *= -1
		get_parent().move(direction * SPEED * delta)
	
	if(direction.x > 0):
		get_node("../Sprite/Animation").play("walk e")
	elif(direction.x < 0):
		get_node("../Sprite/Animation").play("walk w")
	elif(direction.y < 0):
		get_node("../Sprite/Animation").play("walk n")
	else:
		get_node("../Sprite/Animation").play("walk s")

func _on_timer_timeout():
	var r = randf()
	if(r < 0.5):
		pass # don't change direction
	if(r < 0.6):
		direction = Vector2(0, -1)
	elif(r < 0.7):
		direction = Vector2(0, 1)
	elif(r < 0.8):
		direction = Vector2(-1, 0)
	elif(r < 0.9):
		direction = Vector2(1, 0)
	else:
		direction = Vector2(0, 0)