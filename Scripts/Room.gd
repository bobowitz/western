extends Node

var room_type
var screen_hitbox
var up_hitbox
var down_hitbox
var left_hitbox
var right_hitbox

func add_room_hitboxes():
	add_child(screen_hitbox.instance())
	add_child(up_hitbox.instance())
	add_child(down_hitbox.instance())
	add_child(left_hitbox.instance())
	add_child(right_hitbox.instance())

func remove_room_hitboxes():
	get_node("ScreenArea").queue_free()
	remove_child(get_node("ScreenArea"))
	get_node("OutOfBoundsUp").queue_free()
	remove_child(get_node("OutOfBoundsUp"))
	get_node("OutOfBoundsDown").queue_free()
	remove_child(get_node("OutOfBoundsDown"))
	get_node("OutOfBoundsLeft").queue_free()
	remove_child(get_node("OutOfBoundsLeft"))
	get_node("OutOfBoundsRight").queue_free()
	remove_child(get_node("OutOfBoundsRight"))

func set_loc(loc):
	set_pos(loc * WorldConstants.ROOM_SIZE)

func get_loc():
	return (get_pos() / WorldConstants.ROOM_SIZE).floor()

func get_room_type():
	return room_type

func set_room_type(r):
	room_type = r
	if(r == WorldConstants.SALOON):
		get_node("Background").set_texture(RoomTextures.saloon_tex)
		add_child(Hitboxes.saloon.instance())
		add_child(Hitboxes.saloon_bullet.instance())
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

func _ready():
	screen_hitbox = preload("res://Scenes/Hitboxes/ScreenArea.tscn")
	up_hitbox = preload("res://Scenes/Hitboxes/OutOfBoundsUp.tscn")
	down_hitbox = preload("res://Scenes/Hitboxes/OutOfBoundsDown.tscn")
	left_hitbox = preload("res://Scenes/Hitboxes/OutOfBoundsLeft.tscn")
	right_hitbox = preload("res://Scenes/Hitboxes/OutOfBoundsRight.tscn")