extends Node

var room_type

func set_loc(loc):
	set_pos(loc * WorldConstants.room_size)

func set_loc_tween(loc, speed):
	get_node("Tween").interpolate_method(self, "set_pos", get_pos(), loc * WorldConstants.room_size, speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
	get_node("Tween").start()

func get_loc():
	return (get_pos() / WorldConstants.room_size).floor()

func get_room_type():
	return room_type

func set_room_type(r):
	room_type = r
	if(r == WorldConstants.SALOON):
		get_node("Background").set_texture(RoomTextures.saloon_tex)
		add_child(Hitboxes.saloon.instance())
	elif(r == WorldConstants.INN):
		get_node("Background").set_texture(RoomTextures.inn_tex)
	elif(r == WorldConstants.WALL_N):
		get_node("Background").set_texture(RoomTextures.wall_n_tex)
	elif(r == WorldConstants.WALL_NW):
		get_node("Background").set_texture(RoomTextures.wall_nw_tex)
	elif(r == WorldConstants.WALL_W):
		get_node("Background").set_texture(RoomTextures.wall_w_tex)
	elif(r == WorldConstants.WALL_SW):
		get_node("Background").set_texture(RoomTextures.wall_sw_tex)
	elif(r == WorldConstants.WALL_S):
		get_node("Background").set_texture(RoomTextures.wall_s_tex)
	elif(r == WorldConstants.WALL_SE):
		get_node("Background").set_texture(RoomTextures.wall_sw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_E):
		get_node("Background").set_texture(RoomTextures.wall_w_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_NE):
		get_node("Background").set_texture(RoomTextures.wall_nw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_CORNER_NW):
		get_node("Background").set_texture(RoomTextures.wall_corner_nw_tex)
	elif(r == WorldConstants.WALL_CORNER_SW):
		get_node("Background").set_texture(RoomTextures.wall_corner_sw_tex)
	elif(r == WorldConstants.WALL_CORNER_SE):
		get_node("Background").set_texture(RoomTextures.wall_corner_sw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_CORNER_NE):
		get_node("Background").set_texture(RoomTextures.wall_corner_nw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_DESTROY_N):
		get_node("Background").set_texture(RoomTextures.wall_destroy_n_tex)
	elif(r == WorldConstants.WALL_DESTROY_W):
		get_node("Background").set_texture(RoomTextures.wall_destroy_w_tex)
	elif(r == WorldConstants.WALL_DESTROY_S):
		get_node("Background").set_texture(RoomTextures.wall_destroy_s_tex)
	elif(r == WorldConstants.WALL_DESTROY_E):
		get_node("Background").set_texture(RoomTextures.wall_destroy_w_tex)
		get_node("Background").set_flip_h(true)