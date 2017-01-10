extends Node

# ONLY ONE ITEM EQUIPPABLE AT A TIME RIGHT NOW

signal equipped_item

var GRID_WIDTH = 8.0
var GRID_HEIGHT = 8.0
var DESCRIP_WIDTH = 256
var BOX_SIZE = Vector2(32, 32)
var GAP_SIZE = Vector2(2, 2)
var BORDER = 2
var BOX_COLOR = Color(0.2, 0.2, 0.25, 0.75)
var BOX_SELECT_COLOR = Color(0.8, 0.8, 0.9, 0.75)
var EQUIP_COLOR = Color(1, 0, 0)

var ammo_count = 100
var money_count = 0
var items = [] # array of items
var open = false
var font

func add_money(count):
	money_count += count

func subtract_money(count):
	money_count -= count

func add_ammo(count):
	ammo_count += count

func subtract_ammo(count):
	ammo_count -= count

func get_ammo():
	return ammo_count

func get_money():
	return money_count

func get_equipped():
	for item in items:
		if(item.equipped):
			return item

func get_equipped_ID():
	return get_equipped().ID

func add_item_ID(i):
	for item in items:
		if(item.stackable and item.ID == i):
			item.count += 1
			return
	var new_item = Item.new()
	new_item.set_ID(i)
	items.push_back(new_item)

func add_item(i):
	if(i.get_ID() >= ItemConstants.FIRST_GUN):
		add_gun(i)
	else:
		add_item_ID(i.get_ID())

func add_gun(g):
	var new_item = Item.new()
	new_item.gun_stats = g.gun_stats
	new_item.set_ID(g.get_ID())
	items.push_back(new_item)

func _ready():
	font = preload("res://Fonts/western.fnt")
	
	var scr_center = WorldConstants.ROOM_SIZE / 2
	var gui_size = Vector2(GRID_WIDTH * (BOX_SIZE.x + GAP_SIZE.x) - GAP_SIZE.x, \
		GRID_HEIGHT * (BOX_SIZE.y + GAP_SIZE.y) - GAP_SIZE.y)
	get_node("DescriptionLabel").set_pos(Vector2(2, 2) + Vector2(scr_center.x + gui_size.x / 2 - DESCRIP_WIDTH / 2 + BORDER, scr_center.y - gui_size.y / 2))
	get_node("DescriptionLabel").set_hidden(true)
	
	var first_gun_item = preload("res://Scenes/Item.tscn").instance()
	first_gun_item.set_ID(ItemConstants.FIRST_GUN)
	first_gun_item.gun_stats = preload("res://Scenes/Guns/WeaponStats.tscn").instance()
	add_item(first_gun_item)
	items[0].equipped = true
	call_deferred("emit_signal", "equipped_item", items[0])
	
	set_process_input(true)
	set_process(true)

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
	if(open and event.type == InputEvent.MOUSE_BUTTON):
		if(event.button_index == BUTTON_LEFT and event.pressed):
			var mouse_pos = get_viewport().get_mouse_pos()
			
			var scr_center = WorldConstants.ROOM_SIZE / 2
			var gui_size = Vector2(GRID_WIDTH * (BOX_SIZE.x + GAP_SIZE.x) - GAP_SIZE.x, \
			GRID_HEIGHT * (BOX_SIZE.y + GAP_SIZE.y) - GAP_SIZE.y)
			var index = 0
			for y in range(scr_center.y - gui_size.y / 2, \
					   scr_center.y + gui_size.y / 2, \
					   BOX_SIZE.y + GAP_SIZE.y):
				for x in range(scr_center.x - gui_size.x / 2 - DESCRIP_WIDTH / 2, \
						   scr_center.x + gui_size.x / 2 - DESCRIP_WIDTH / 2, \
						   BOX_SIZE.x + GAP_SIZE.x):
					if(Rect2(x, y, BOX_SIZE.x, BOX_SIZE.y).has_point(mouse_pos) and index < items.size() and items[index].equippable):
						items[index].equipped = not items[index].equipped
						for item in items:
							if(item != items[index]):
								item.equipped = false
						if(items[index].equipped):
							emit_signal("equipped_item", items[index])
						else:
							emit_signal("equipped_item", null)
					index += 1

func _process(delta):
	get_node("DescriptionLabel").set_hidden(!open)
	if(open):
		update()

func _draw():
	if(open):
		var mouse_pos = get_viewport().get_mouse_pos()
		
		var scr_center = WorldConstants.ROOM_SIZE / 2
		var gui_size = Vector2(GRID_WIDTH * (BOX_SIZE.x + GAP_SIZE.x) - GAP_SIZE.x, \
		GRID_HEIGHT * (BOX_SIZE.y + GAP_SIZE.y) - GAP_SIZE.y)
		var index = 0
		draw_string(font, Vector2(scr_center.x - 32, \
		scr_center.y - gui_size.y / 2 - 16), "Inventory", WorldConstants.OUTLINE_COLOR)
		
		# description
		draw_rect(Rect2(scr_center.x + gui_size.x / 2 - DESCRIP_WIDTH / 2 + BORDER, scr_center.y - gui_size.y / 2, DESCRIP_WIDTH, gui_size.y), BOX_COLOR)
		
		get_node("DescriptionLabel").set_text("")
		for y in range(scr_center.y - gui_size.y / 2, \
					   scr_center.y + gui_size.y / 2, \
					   BOX_SIZE.y + GAP_SIZE.y):
			for x in range(scr_center.x - gui_size.x / 2 - DESCRIP_WIDTH / 2, \
						   scr_center.x + gui_size.x / 2 - DESCRIP_WIDTH / 2, \
						   BOX_SIZE.x + GAP_SIZE.x):
				var box = Rect2(x, y, BOX_SIZE.x, BOX_SIZE.y)
				var color = BOX_COLOR
				if(box.has_point(mouse_pos)):
					color = BOX_SELECT_COLOR
				draw_rect(box, color)
				if(index < items.size()):
					if(box.has_point(mouse_pos)):
						get_node("DescriptionLabel").set_text(items[index].description)
					
					draw_item(items[index], Vector2(x, y))
					if(items[index].equipped):
						draw_line(Vector2(x, y), Vector2(x + BOX_SIZE.x, y), EQUIP_COLOR, 2)
						draw_line(Vector2(x, y), Vector2(x, y + BOX_SIZE.y), EQUIP_COLOR, 2)
						draw_line(Vector2(x + BOX_SIZE.x, y), Vector2(x + BOX_SIZE.x, y + BOX_SIZE.y), EQUIP_COLOR, 2)
						draw_line(Vector2(x, y + BOX_SIZE.y), Vector2(x + BOX_SIZE.x, y + BOX_SIZE.y), EQUIP_COLOR, 2)
					if(items[index].count > 1):
						draw_string(font, Vector2(x + 1, y + 12), str(items[index].count), Color(1, 1, 1))
				index += 1

func draw_item(item, position):
	if(item.is_gun):
		var item_tex = preload("res://Sprites/guniconset.png")
		draw_texture_rect_region(item_tex, \
				Rect2(position, BOX_SIZE), \
				Rect2(int((item.ID - ItemConstants.FIRST_GUN) * BOX_SIZE.x) % item_tex.get_width(), \
				BOX_SIZE.y * floor((item.ID - ItemConstants.FIRST_GUN) * BOX_SIZE.x / item_tex.get_width()), \
				BOX_SIZE.x, BOX_SIZE.y))
	else:
		var item_tex = preload("res://Sprites/itemset.png")
		draw_texture_rect_region(item_tex, \
				Rect2(position, BOX_SIZE), \
				Rect2(int(item.ID * BOX_SIZE.x) % item_tex.get_width(), \
				BOX_SIZE.y * floor(item.ID * BOX_SIZE.x / item_tex.get_width()), \
				BOX_SIZE.x, BOX_SIZE.y))

class Item:
	var description = ""
	var equippable = false
	var equipped = false
	var ID = 0
	var stackable = true
	var count = 1
	var is_gun = false
	var gun_stats
	
	func set_ID(id):
		ID = id
		if(ID == ItemConstants.REVOLVER_TINY):
			is_gun = true
			equippable = true
			stackable = true
			description = "tiny revolver\n" + gun_stats.description_string()
		if(ID == ItemConstants.REVOLVER_SMALL):
			is_gun = true
			equippable = true
			stackable = true
			description = "smol revolver\n" + gun_stats.description_string()
		if(ID == ItemConstants.REVOLVER_MEDIUM):
			is_gun = true
			equippable = true
			stackable = true
			description = "med revolver\n" + gun_stats.description_string()
		if(ID == ItemConstants.REVOLVER_LARGE):
			is_gun = true
			equippable = true
			stackable = true
			description = "large revolver\n" + gun_stats.description_string()
		if(ID == ItemConstants.REVOLVER_HUGE):
			is_gun = true
			equippable = true
			stackable = true
			description = "huge revolver\n" + gun_stats.description_string()
		if(ID == ItemConstants.BANANA):
			is_gun = true
			equippable = true
			stackable = true
			description = "Banana\n" + gun_stats.description_string()