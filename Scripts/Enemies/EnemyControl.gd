extends Node

var SPEED = 100.0
var direction = Vector2(0, 0)

func _ready():
	direction = Vector2(0, 1)
	get_node("../Sprite/Animation").play_force("jump")
	set_fixed_process(true)

func _fixed_process(delta):
	get_parent().move(direction * SPEED * delta)
	
	if(not Rect2(Vector2(0, 0), WorldConstants.ROOM_SIZE).has_point(get_parent().get_pos() + get_parent().get_shape(0).get_extents())):
		direction *= -1
		get_parent().move(direction * SPEED * delta)
	elif(get_parent().is_colliding()):
		direction *= -1
		get_parent().move(direction * SPEED * delta)
		direction = direction.rotated(PI / 2)

func _on_animation_finished():
	var r = randf()
	if(r < 0.65):
		direction = (get_node("/root/Game/Player").get_node("Body").get_center() - get_parent().get_center()).normalized()
	else:
		direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
		direction = direction.normalized()
	get_node("../Sprite/Animation").play_force("jump")