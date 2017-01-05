extends Node

var GRID_WIDTH = 5.0
var GRID_HEIGHT = 5.0
var BOX_SIZE = Vector2(32, 32)
var GAP_SIZE = Vector2(2, 2)

var items = [] # array of item counts. items[ID] = count
var open = false
var item_tex
var font

func add_item(item):
	items[item.ID] += 1

func _ready():
	var label = Label.new()
	font = label.get_font("") # TEMPORARY, ADD A REAL FONT LATER
	
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
		var index = 0
		draw_string(font, Vector2(WorldConstants.ROOM_SIZE.x / 2 - 32, \
		WorldConstants.ROOM_SIZE.y / 2 - GRID_HEIGHT * (BOX_SIZE.y + GAP_SIZE.y) / 2 - 16), "Inventory", Color(0, 0, 0))
		for y in range(WorldConstants.ROOM_SIZE.y / 2 - GRID_HEIGHT * (BOX_SIZE.y + GAP_SIZE.y) / 2, \
					   WorldConstants.ROOM_SIZE.y / 2 + GRID_HEIGHT * (BOX_SIZE.y + GAP_SIZE.y) / 2, \
					   BOX_SIZE.y + GAP_SIZE.y):
			for x in range(WorldConstants.ROOM_SIZE.x / 2 - GRID_WIDTH * (BOX_SIZE.x + GAP_SIZE.x) / 2, \
						   WorldConstants.ROOM_SIZE.x / 2 + GRID_WIDTH * (BOX_SIZE.x + GAP_SIZE.x) / 2, \
						   BOX_SIZE.x + GAP_SIZE.x):
				draw_rect(Rect2(x, y, BOX_SIZE.x, BOX_SIZE.y), Color(0, 0, 0, 0.5))
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