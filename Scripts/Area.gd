extends Node

var INNS = 1
var SALOONS = 3

var WASTELAND = 0
var SALOON = 1
var INN = 2
var WALL = 3
var WALL_DESTROY = 4

var area_w = 8
var area_h = 8
var branched = false
var branched_dir = Vector2(0, 0)
var branching_dir = Vector2(0, 0)

func set_loc(loc):
	set_pos(loc * 32)

func get_loc():
	return get_pos() / 32

func is_branched():
	return branched

func set_branched(b):
	branched = b

func pick_room():
	var radius = 1
	
	var room_pos
	while true:
		room_pos = Vector2(randi() % (area_w-2)+1, randi() % (area_h-2)+1)
		
		var nearby_room = false
		for yy in range(room_pos.y - radius, room_pos.y + radius + 1):
			for xx in range(room_pos.x - radius, room_pos.x + radius + 1):
				if(xx < 0 or yy < 0 or xx >= area_w or yy >= area_h):
					continue
				var lin_pos = xx + yy * area_w
				if(get_node("Room" + str(lin_pos)).get_room_type() != WASTELAND):
					nearby_room = true
					break
			if(nearby_room):
				break
		if(not nearby_room):
			break
	return room_pos

func fill_wastelands(room):
	for i in range(area_w * area_h):
		var node = room.instance()
		node.set_name("Room" + str(i))
		node.get_node("Sprite").set_pos(Vector2((i % area_w) * 4, int(i / area_h) * 4))
		node.set_room_type(WASTELAND)
		add_child(node)

func place_saloons(room):
	var alt_tex = load("res://Sprites/room.png")
	
	for saloons in range(SALOONS):
		var room_pos = pick_room()
		var linear_room_pos = room_pos.x + room_pos.y * area_w
		get_node("Room" + str(linear_room_pos)).get_node("Sprite").set_texture(alt_tex)
		get_node("Room" + str(linear_room_pos)).set_room_type(SALOON)

func place_inns(room):
	var alt_tex_2 = load("res://Sprites/room2.png")
	
	for inns in range(INNS):
		var room_pos = pick_room()
		var linear_room_pos = room_pos.x + room_pos.y * area_w
		get_node("Room" + str(linear_room_pos)).get_node("Sprite").set_texture(alt_tex_2)
		get_node("Room" + str(linear_room_pos)).set_room_type(INN)

func add_walls_on_side(direction):
	if(branched_dir == -direction):
		return
	
	var wall_tex = load("res://Sprites/room_wall.png")
	var wall_destroy_tex = load("res://Sprites/room_destructible_wall.png")
	var type = WALL
	var tex = wall_tex
	if(branching_dir == direction):
		type = WALL_DESTROY
		tex = wall_destroy_tex
	if(direction == Vector2(0, -1)):
		for pos in range(1, area_w - 1):
			get_node("Room" + str(pos)).get_node("Sprite").set_texture(tex)
			get_node("Room" + str(pos)).set_room_type(type)
	if(direction == Vector2(0, 1)):
		for pos in range(area_w * (area_h - 1) + 1, area_w * area_h - 1):
			get_node("Room" + str(pos)).get_node("Sprite").set_texture(tex)
			get_node("Room" + str(pos)).set_room_type(type)
	if(direction == Vector2(-1, 0)):
		for pos in range(area_w, area_w * (area_h - 1), area_w):
			get_node("Room" + str(pos)).get_node("Sprite").set_texture(tex)
			get_node("Room" + str(pos)).set_room_type(type)
	if(direction == Vector2(1, 0)):
		for pos in range(area_w * 2 - 1, area_w * (area_h - 1), area_w):
			get_node("Room" + str(pos)).get_node("Sprite").set_texture(tex)
			get_node("Room" + str(pos)).set_room_type(type)

func add_corners():
	var wall_tex = load("res://Sprites/room_wall.png")
	get_node("Room" + str(0)).get_node("Sprite").set_texture(wall_tex)
	get_node("Room" + str(0)).set_room_type(WALL)
	get_node("Room" + str(area_w - 1)).get_node("Sprite").set_texture(wall_tex)
	get_node("Room" + str(area_w - 1)).set_room_type(WALL)
	get_node("Room" + str(area_w * (area_h - 1))).get_node("Sprite").set_texture(wall_tex)
	get_node("Room" + str(area_w * (area_h - 1))).set_room_type(WALL)
	get_node("Room" + str(area_w * area_h - 1)).get_node("Sprite").set_texture(wall_tex)
	get_node("Room" + str(area_w * area_h - 1)).set_room_type(WALL)

func add_walls():
	add_corners()
	if(branched_dir == Vector2(0, 0)):
		return
	add_walls_on_side(Vector2(0, -1))
	add_walls_on_side(Vector2(0, 1))
	add_walls_on_side(Vector2(-1, 0))
	add_walls_on_side(Vector2(1, 0))

func _ready():
	randomize()
	
	var room = load("res://Scenes/Room.tscn")
	
	fill_wastelands(room)
	place_saloons(room)
	place_inns(room)