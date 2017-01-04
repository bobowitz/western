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

func _ready():
	saloon_tex = preload("res://Sprites/room_saloon.png")
	inn_tex = preload("res://Sprites/room_inn.png")
	wall_n_tex = preload("res://Sprites/room_wall_n.png")
	wall_nw_tex = preload("res://Sprites/room_wall_nw.png")
	wall_w_tex = preload("res://Sprites/room_wall_w.png")
	wall_sw_tex = preload("res://Sprites/room_wall_sw.png")
	wall_s_tex = preload("res://Sprites/room_wall_s.png")
	wall_corner_nw_tex = preload("res://Sprites/room_wall_corner_nw.png")
	wall_corner_sw_tex = preload("res://Sprites/room_wall_corner_sw.png")
	wall_destroy_n_tex = preload("res://Sprites/room_wall_destroy_n.png")
	wall_destroy_w_tex = preload("res://Sprites/room_wall_destroy_w.png")
	wall_destroy_s_tex = preload("res://Sprites/room_wall_destroy_s.png")