extends Node2D

var HEALTH_BAR_W = 184
var HEALTH_BAR_H = 12
var HEALTH_BAR_X = 4

func flash_ammo():
	get_node("AmmoFlashTimer").start()

func draw_text_outline(font, pos, text, outline_col, text_col):
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			draw_string(font, Vector2(x, y) + pos, text, outline_col)
	draw_string(font, pos, text, text_col)

func _ready():
	set_process(true)

func _process(delta):
	update()

func _draw():
	# health bar
	
	var font = preload("res://Fonts/western.fnt")
	var health = get_node("../../Health").get_hp()
	var full_health = get_node("../../Health").get_full_hp()
	var health_text = str(health) + "  /  " + str(full_health)
	draw_rect(Rect2(HEALTH_BAR_X, 16 - HEALTH_BAR_H / 2, HEALTH_BAR_W, HEALTH_BAR_H), WorldConstants.OUTLINE_COLOR)
	draw_rect(Rect2(HEALTH_BAR_X + 1, 17 - HEALTH_BAR_H / 2, HEALTH_BAR_W - 2, HEALTH_BAR_H - 4), WorldConstants.HIGHLIGHT_COLOR)
	draw_rect(Rect2(HEALTH_BAR_X + 2, 18 - HEALTH_BAR_H / 2, HEALTH_BAR_W - 4, HEALTH_BAR_H - 6), WorldConstants.HEALTH_RED)
	draw_rect(Rect2(HEALTH_BAR_X + 2, 18 - HEALTH_BAR_H / 2, (float(health) / full_health) * (HEALTH_BAR_W - 4), HEALTH_BAR_H - 6), WorldConstants.HEALTH_GREEN)
	
	draw_text_outline(font, \
	Vector2(HEALTH_BAR_W / 2 + HEALTH_BAR_X - \
	font.get_string_size(health_text).x / 2, 20), \
	health_text, WorldConstants.OUTLINE_COLOR, WorldConstants.HIGHLIGHT_COLOR)
	
	# ammo count
	
	draw_texture_rect_region(preload("res://Sprites/itemset.png"), \
					Rect2(4, 24, 32, 32), \
					Rect2(0, 0, 32, 32))
	
	var ammo_text = str(get_node("../Inventory").get_ammo())
	
	var color = WorldConstants.HIGHLIGHT_COLOR
	if(get_node("AmmoFlashTimer").get_time_left() > 0 and OS.get_ticks_msec() % 100 < 60):
		color = WorldConstants.HEALTH_RED
	draw_text_outline(font, \
	Vector2(HEALTH_BAR_X + 36, 46), \
	ammo_text, WorldConstants.OUTLINE_COLOR, color)
	
	# money count
	
	draw_texture_rect_region(preload("res://Sprites/itemset.png"), \
					Rect2(HEALTH_BAR_X + 40 + max(32, font.get_string_size(ammo_text).x), 24, 32, 32), \
					Rect2(32, 0, 32, 32))
	
	var money_text = str(get_node("../Inventory").get_money())
	
	draw_text_outline(font, \
	Vector2(HEALTH_BAR_X + 76 + max(32, font.get_string_size(ammo_text).x), 46), \
	money_text, WorldConstants.OUTLINE_COLOR, WorldConstants.HIGHLIGHT_COLOR)