extends Node2D

var text

func _draw():
	var font = preload("res://Fonts/western.fnt")
	for x_off in [-1, 0, 1]:
		for y_off in [-1, 0, 1]:
			draw_string(font, \
				WorldConstants.ROOM_SIZE / 2 - font.get_string_size(text) / 2 + Vector2(x_off, y_off), \
				text, WorldConstants.OUTLINE_COLOR)
	draw_string(font, \
				WorldConstants.ROOM_SIZE / 2 - font.get_string_size(text) / 2, \
				text, Color(1, 1, 1))