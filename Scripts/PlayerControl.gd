extends Node

# Player Control
# deals with input + animations

signal player_control_input

var frozen = false
var speed = 150.0
var direction = Vector2(0, 0)
var knockback_velocity = Vector2(0, 0)

func freeze():
	get_node("../Sprite/Animation").play("idle")
	frozen = true

func unfreeze():
	frozen = false

func get_direction():
	return direction

func _ready():
	set_fixed_process(true)
	set_process_input(true)

func knockback(knock_dir):
	get_parent().move(knock_dir * 10)
	knockback_velocity = knock_dir * 300

func _input(event):
	if(not frozen):
		emit_signal("player_control_input", event)

func _fixed_process(delta):
	get_parent().move(knockback_velocity * delta)
	knockback_velocity *= 0.85
	if(not frozen and abs(knockback_velocity.x) < 10 and abs(knockback_velocity.y) < 10):
		knockback_velocity = Vector2(0, 0)
		
		speed = 150.0
		if(Input.is_key_pressed(KEY_SHIFT)):
			speed = 400.0
		var translate = Vector2(0, 0)
		if(Input.is_key_pressed(KEY_W)):
			translate += Vector2(0, -1)
		if(Input.is_key_pressed(KEY_S)):
			translate += Vector2(0, 1)
		if(Input.is_key_pressed(KEY_A)):
			translate += Vector2(-1, 0)
		if(Input.is_key_pressed(KEY_D)):
			translate += Vector2(1, 0)
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