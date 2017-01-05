extends Sprite

var x_offset = 16
var bullet
var angle = 0
var recoil = 0

func shoot():
	var b = bullet.instance()
	b.set_pos(get_parent().get_pos() + get_pos() + Vector2(0, x_offset).rotated(angle + PI))
	b.set_direction(angle)
	b.add_to_group("bullets")
	get_node("/root/Game/World").add_child(b)
	
	recoil = 1
	get_parent().move(-Vector2(0, 2).rotated(angle + PI))

func _ready():
	get_node("Timer").set_active(true)
	get_node("Timer").start()
	get_node("Timer").set_one_shot(true)
	bullet = preload("res://Scenes/Bullet.tscn")
	
	set_process(true)
	get_node("../PlayerControl").connect("player_control_input", self, "_on_player_control_input")

func _process(delta):
	if(Input.is_mouse_button_pressed(1) and not get_node("../PlayerControl").frozen \
	and get_node("Timer").get_time_left() == 0):
		get_node("/root/Game/Camera").shake(Vector2(0, 10).rotated(angle + PI))
		shoot()
		get_node("Timer").set_wait_time(0.1)
		get_node("Timer").start()
	
	#print(get_parent().get_pos().angle_to_point(get_viewport().get_mouse_pos()))
	angle = (get_pos() + get_parent().get_pos()). \
	angle_to_point(get_viewport().get_mouse_pos() + get_node("/root/Game/Camera").get_pixel_pos())
	if(-PI / 2 < angle and angle < PI / 2):
		set_z(-1)
	else:
		set_z(0)
	if(angle > 0):
		set_rot(angle - PI / 2 - recoil * PI / 8)
		var width = get_texture().get_width() / get_hframes()
		set_flip_h(true)
		set_offset(Vector2(-x_offset - width + recoil * 8, -16))
	else:
		set_rot(angle + PI / 2 + recoil * PI / 8)
		set_flip_h(false)
		set_offset(Vector2(x_offset - recoil * 8, -16))
	
	recoil *= 0.85

func _on_player_control_input(event):
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if(not get_node("../PlayerControl").frozen \
			and get_node("Timer").get_time_left() == 0):
				get_node("/root/Game/Camera").shake(Vector2(0, 10).rotated(angle + PI))
				shoot()
				get_node("Timer").set_wait_time(0.1)
				get_node("Timer").start()