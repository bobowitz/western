extends Node

var x_offset = 16
var angle = 0
var recoil = 0

func shoot():
	if(get_node("../../HUD/Inventory").get_ammo() - get_node("../WeaponStats")._ammo_per_shot < 0):
		get_node("../../HUD/HUD").flash_ammo()
	else:
		get_parent().shoot()
		get_node("../../HUD/Inventory").subtract_ammo(get_node("../WeaponStats")._ammo_per_shot)
		get_node("FireRateTimer").start()

func _ready():
	set_fixed_process(true)
	set_process(true)
	get_node("../../PlayerControl").connect("player_control_input", self, "_on_player_control_input")

func _process(delta):
	if(!get_node("../WeaponStats")._hold_to_shoot):
		return
	
	if(Input.is_mouse_button_pressed(1) and get_node("FireRateTimer").get_time_left() == 0 and !get_node("../../PlayerControl").frozen):
		shoot()

func _fixed_process(delta):
	angle = (get_parent().get_pos() + get_parent().get_parent().get_pos()). \
	angle_to_point(get_viewport().get_mouse_pos() + get_node("/root/Game/Camera").get_pixel_pos())
	if(-PI / 2 < angle and angle < PI / 2):
		get_parent().set_z(-1)
	else:
		get_parent().set_z(0)
	if(angle > 0):
		get_parent().set_rot(angle - PI / 2 - recoil * PI / 8)
		var width = get_parent().get_texture().get_width() / get_parent().get_hframes()
		get_parent().set_flip_h(true)
		get_parent().set_offset(Vector2(-x_offset - width + recoil * 8, -16))
	else:
		get_parent().set_rot(angle + PI / 2 + recoil * PI / 8)
		get_parent().set_flip_h(false)
		get_parent().set_offset(Vector2(x_offset - recoil * 8, -16))
	recoil *= 0.85

func _on_player_control_input(event):
	if(get_node("../WeaponStats")._hold_to_shoot):
		return
	
	if event.type == InputEvent.MOUSE_BUTTON:
		if event.button_index == BUTTON_LEFT and event.pressed and get_node("FireRateTimer").get_time_left() == 0:
			shoot()