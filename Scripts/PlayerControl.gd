extends Node

# Player Control
# deals with input + animations

var frozen = false
var speed = 150.0
var direction = Vector2(0, 0)

func freeze():
	frozen = true

func unfreeze():
	frozen = false

func translate_tween(transform, speed):
	freeze()
	get_node("../Sprite/Animation").play("idle")
	get_node("Tween").interpolate_method(get_parent(), \
		"set_pos", \
		get_parent().get_pos(), get_parent().get_pos() + transform, \
		speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	get_node("Tween").start()

func get_direction():
	return direction

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if(not frozen):
		var translate = Vector2(0, 0)
		if(Input.is_key_pressed(KEY_W)):
			translate += Vector2(0, -1)
		if(Input.is_key_pressed(KEY_S)):
			translate += Vector2(0, 1)
		if(Input.is_key_pressed(KEY_A)):
			translate += Vector2(-1, 0)
		if(Input.is_key_pressed(KEY_D)):
			translate += Vector2(1, 0)
		if(translate != Vector2(0, 0)):
			direction = translate
		translate = translate.normalized()
		get_parent().move(translate * speed * delta)
		if(translate.x > 0):
			get_node("../Sprite/Animation").play("walk e")
		elif(translate.x < 0):
			get_node("../Sprite/Animation").play("walk w")
		elif(translate.y > 0):
			get_node("../Sprite/Animation").play("walk s")
		elif(translate.y < 0):
			get_node("../Sprite/Animation").play("walk n")
		else:
			get_node("../Sprite/Animation").play("idle")

func _on_tween_complete(object, key):
	unfreeze()
