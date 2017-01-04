extends Sprite

var x_offset = 16
var bullet
var angle

func shoot():
	var b = bullet.instance()
	print(Vector2(0, x_offset).rotated(angle))
	b.set_pos(get_parent().get_pos() + get_pos() + Vector2(0, x_offset).rotated(angle + PI))
	b.set_direction(angle)
	b.add_to_group("bullets")
	get_node("/root/Game/World").add_child(b)

func _ready():
	bullet = preload("res://Scenes/Bullet.tscn")
	
	set_process(true)
	set_process_input(true)

func _process(delta):
	#print(get_parent().get_pos().angle_to_point(get_viewport().get_mouse_pos()))
	angle = (get_pos() + get_parent().get_pos()). \
	angle_to_point(get_viewport().get_mouse_pos())
	if(angle > 0):
		set_rot(angle - PI / 2)
		var width = get_texture().get_width() / get_hframes()
		set_flip_h(true)
		set_offset(Vector2(-x_offset - width, -16))
	else:
		set_rot(angle + PI / 2)
		set_flip_h(false)
		set_offset(Vector2(x_offset, -16))

func _input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_LEFT and event.pressed:
			shoot()