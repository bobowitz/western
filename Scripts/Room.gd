extends Node

var saloon_tex
var inn_tex
var wall_n_tex
var wall_nw_tex
var wall_w_tex
var wall_sw_tex
var wall_s_tex
var wall_corner_nw_tex
var wall_corner_sw_tex
var wall_destroy_n_tex
var wall_destroy_w_tex
var wall_destroy_s_tex

var CONSTANTS

var room_type

func set_loc(loc):
	set_pos(loc * CONSTANTS.room_size)

func get_loc():
	return (get_pos() / CONSTANTS.room_size).floor()

func get_room_type():
	return room_type

func set_room_type(r):
	room_type = r
	if(r == CONSTANTS.SALOON):
		get_node("Background").set_texture(saloon_tex)
	elif(r == CONSTANTS.INN):
		get_node("Background").set_texture(inn_tex)
	elif(r == CONSTANTS.WALL_N):
		get_node("Background").set_texture(wall_n_tex)
	elif(r == CONSTANTS.WALL_NW):
		get_node("Background").set_texture(wall_nw_tex)
	elif(r == CONSTANTS.WALL_W):
		get_node("Background").set_texture(wall_w_tex)
	elif(r == CONSTANTS.WALL_SW):
		get_node("Background").set_texture(wall_sw_tex)
	elif(r == CONSTANTS.WALL_S):
		get_node("Background").set_texture(wall_s_tex)
	elif(r == CONSTANTS.WALL_SE):
		get_node("Background").set_texture(wall_sw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == CONSTANTS.WALL_E):
		get_node("Background").set_texture(wall_w_tex)
		get_node("Background").set_flip_h(true)
	elif(r == CONSTANTS.WALL_NE):
		get_node("Background").set_texture(wall_nw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == CONSTANTS.WALL_CORNER_NW):
		get_node("Background").set_texture(wall_corner_nw_tex)
	elif(r == CONSTANTS.WALL_CORNER_SW):
		get_node("Background").set_texture(wall_corner_sw_tex)
	elif(r == CONSTANTS.WALL_CORNER_SE):
		get_node("Background").set_texture(wall_corner_sw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == CONSTANTS.WALL_CORNER_NE):
		get_node("Background").set_texture(wall_corner_nw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == CONSTANTS.WALL_DESTROY_N):
		get_node("Background").set_texture(wall_destroy_n_tex)
	elif(r == CONSTANTS.WALL_DESTROY_W):
		get_node("Background").set_texture(wall_destroy_w_tex)
	elif(r == CONSTANTS.WALL_DESTROY_S):
		get_node("Background").set_texture(wall_destroy_s_tex)
	elif(r == CONSTANTS.WALL_DESTROY_E):
		get_node("Background").set_texture(wall_destroy_w_tex)
		get_node("Background").set_flip_h(true)

func _ready():
	CONSTANTS = get_node("/root/WorldConstants")
	
	saloon_tex = load("res://Sprites/room_saloon.png")
	inn_tex = load("res://Sprites/room_inn.png")
	wall_n_tex = load("res://Sprites/room_wall_n.png")
	wall_nw_tex = load("res://Sprites/room_wall_nw.png")
	wall_w_tex = load("res://Sprites/room_wall_w.png")
	wall_sw_tex = load("res://Sprites/room_wall_sw.png")
	wall_s_tex = load("res://Sprites/room_wall_s.png")
	wall_corner_nw_tex = load("res://Sprites/room_wall_corner_nw.png")
	wall_corner_sw_tex = load("res://Sprites/room_wall_corner_sw.png")
	wall_destroy_n_tex = load("res://Sprites/room_wall_destroy_n.png")
	wall_destroy_w_tex = load("res://Sprites/room_wall_destroy_w.png")
	wall_destroy_s_tex = load("res://Sprites/room_wall_destroy_s.png")