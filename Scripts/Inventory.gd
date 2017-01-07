extends Node

var GRID_WIDTH = 6.0
var GRID_HEIGHT = 3.0
var BOX_SIZE = Vector2(32, 32)
var GAP_SIZE = Vector2(2, 2)
var BORDER = 2
var GUI_COLOR = Color(0, 0, 0, 0) # no borders
var BOX_COLOR = Color(0.2, 0.2, 0.25, 0.75)

var items = [] # array of item counts. items[ID] = count
var open = false
var item_tex
var font

func add_item(item):
	items[item.ID] += 1

func _ready():
	font = preload("res://Fonts/western.fnt")
	
	items = []
	for i in range(ItemConstants.ITEMS):
		items.push_back(0)
	
	item_tex = preload("res://Sprites/itemset.png")
	
	set_process_input(true)

func _input(event):
	if(event.is_action_pressed("ui_select")):
		if(open):
			open = false
			update()
			get_node("../../PlayerControl").unfreeze()
		elif(not get_node("../../PlayerControl").frozen):
			open = true
			update()
			get_node("../../PlayerControl").freeze()

func _draw():
	if(open):
		var scr_center = WorldConstants.ROOM_SIZE / 2
		var gui_size = Vector2(GRID_WIDTH * (BOX_SIZE.x + GAP_SIZE.x) - GAP_SIZE.x, \
		GRID_HEIGHT * (BOX_SIZE.y + GAP_SIZE.y) - GAP_SIZE.y)
		var index = 0
		draw_string(font, Vector2(scr_center.x - 32, \
		scr_center.y - gui_size.y / 2 - 16), "Inventory", WorldConstants.OUTLINE_COLOR)
		
		draw_rect(Rect2(scr_center - gui_size / 2 - Vector2(BORDER, BORDER), Vector2(BORDER, gui_size.y + BORDER*2)), GUI_COLOR)
		draw_rect(Rect2(scr_center - gui_size / 2 - Vector2(BORDER, BORDER), Vector2(gui_size.x + BORDER*2, BORDER)), GUI_COLOR)
		draw_rect(Rect2(scr_center.x + gui_size.x / 2, scr_center.y - gui_size.y / 2 - BORDER, BORDER, gui_size.y + BORDER*2), GUI_COLOR)
		draw_rect(Rect2(scr_center.x - gui_size.x / 2 - BORDER, scr_center.y + gui_size.y / 2, gui_size.x + BORDER*2, BORDER), GUI_COLOR)
		
		for y in range(scr_center.y - gui_size.y / 2 + BOX_SIZE.y, \
					   scr_center.y + gui_size.y / 2, \
					   BOX_SIZE.y + GAP_SIZE.y):
			draw_rect(Rect2(scr_center.x - gui_size.x / 2 - BORDER, y, gui_size.x + BORDER*2, BORDER), GUI_COLOR)
		
		for x in range(scr_center.x - gui_size.x / 2 + BOX_SIZE.x, \
					   scr_center.x + gui_size.x / 2, \
					   BOX_SIZE.x + GAP_SIZE.x):
			draw_rect(Rect2(x, scr_center.y - gui_size.y / 2 - BORDER, BORDER, gui_size.y + BORDER*2), GUI_COLOR)
		
		for y in range(scr_center.y - gui_size.y / 2, \
					   scr_center.y + gui_size.y / 2, \
					   BOX_SIZE.y + GAP_SIZE.y):
			for x in range(scr_center.x - gui_size.x / 2, \
						   scr_center.x + gui_size.x / 2, \
						   BOX_SIZE.x + GAP_SIZE.x):
				draw_rect(Rect2(x, y, BOX_SIZE.x, BOX_SIZE.y), BOX_COLOR)
				while(index < items.size() and items[index] == 0):
					index += 1
				if(index == items.size()):
					continue
				draw_texture_rect_region(item_tex, \
				Rect2(x, y, BOX_SIZE.x, BOX_SIZE.y), \
				Rect2(int(index * BOX_SIZE.x) % item_tex.get_width(), \
				BOX_SIZE.y * floor(index * BOX_SIZE.x / item_tex.get_width()), \
				BOX_SIZE.x, BOX_SIZE.y))
				draw_string(font, Vector2(x + 1, y + 12), str(items[index]), Color(1, 1, 1))
				index += 1