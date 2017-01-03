extends Node

# Player Control
# deals with input + animations

var speed = 150.0

func _ready():
	set_process(true)

func _process(delta):
	var translate = Vector2(0, 0)
	if(Input.is_key_pressed(KEY_W)):
		translate += Vector2(0, -1)
	if(Input.is_key_pressed(KEY_S)):
		translate += Vector2(0, 1)
	if(Input.is_key_pressed(KEY_A)):
		translate += Vector2(-1, 0)
	if(Input.is_key_pressed(KEY_D)):
		translate += Vector2(1, 0)
	translate = translate.normalized()
	get_parent().translate(translate * speed * delta)
	if(translate.x > 0):
		get_node("../Animation").play("walk e")
	elif(translate.x < 0):
		get_node("../Animation").play("walk w")
	elif(translate.y > 0):
		get_node("../Animation").play("walk s")
	elif(translate.y < 0):
		get_node("../Animation").play("walk n")
	else:
		get_node("../Animation").play("idle")