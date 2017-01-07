extends Node2D

signal killed

var SCALE_TIME = 0.1
var Y_OFFSET = -3
var BAR_HEIGHT = 2
var OUTLINE_THICKNESS = 1

var hp = 1
var full_hp = 1
var bar_width = 16
var first_hit = true

func set_bar_width(w):
	bar_width = w

func set_full_hp(val):
	full_hp = val

func set_hp(val):
	hp = val

func get_hp():
	return hp

func hurt(amount):
	first_hit = get_node("Timer").get_time_left() == 0
	
	hp -= amount
	if(hp > full_hp):
		hp = full_hp
	get_node("Timer").start()
	if(hp <= 0):
		hp = 0
		emit_signal("killed")
	update()

func _ready():
	var parent_width = get_node("../Sprite").get_texture().get_size().x / get_node("../Sprite").get_hframes()
	set_pos(Vector2(parent_width / 2, Y_OFFSET))
	
	set_process(true)

func _process(delta):
	var scale = min(1, get_node("Timer").get_time_left() / SCALE_TIME)
	if(first_hit):
		scale = min(scale, (get_node("Timer").get_wait_time() - get_node("Timer").get_time_left()) / SCALE_TIME)
	set_scale(Vector2(scale, 1))

func _draw():
	if(get_node("Timer").get_time_left() > 0):
		draw_rect(Rect2(-bar_width / 2, Y_OFFSET / 2, bar_width, BAR_HEIGHT).grow(OUTLINE_THICKNESS), WorldConstants.OUTLINE_COLOR)
		draw_rect(Rect2(-bar_width / 2, Y_OFFSET / 2, bar_width, BAR_HEIGHT), WorldConstants.HEALTH_RED)
		draw_rect(Rect2(-bar_width / 2, Y_OFFSET / 2, (float(hp) / full_hp) * bar_width, BAR_HEIGHT), WorldConstants.HEALTH_GREEN)

func _on_timer_timeout():
	update()