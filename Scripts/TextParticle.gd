extends Node2D

var velocity = Vector2(0, -50)
var font
var text
var color = WorldConstants.OUTLINE_COLOR

func set_color(c):
	color = c

func set_text(t):
	text = t

func get_text():
	return text

func _ready():
	font = preload("res://Fonts/western.fnt")
	
	set_fixed_process(true)

func _fixed_process(delta):
	translate(velocity * delta)
	velocity *= 0.95
	if(abs(velocity.y) < 0.1):
		queue_free()
		get_parent().remove_child(self)

func _draw():
	for x_off in [-1, 0, 1]:
		for y_off in [-1, 0, 1]:
			draw_string(font, -font.get_string_size(text) / 2 + Vector2(x_off, y_off), text, WorldConstants.OUTLINE_COLOR)
	draw_string(font, -font.get_string_size(text) / 2, text, color)