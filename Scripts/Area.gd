extends Node

var INNS = 1
var SALOONS = 3

var CONSTANTS

var area_w = 8
var area_h = 8
var branched = false
var branched_dir = Vector2(0, 0)
var branching_dir = Vector2(0, 0)

func set_loc(loc):
	set_pos(loc * Vector2(area_w, area_h) * CONSTANTS.room_size)

func get_loc():
	return get_pos() / (Vector2(area_w, area_h) * CONSTANTS.room_size)

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
				if(get_node("Room" + str(lin_pos)).get_room_type() != CONSTANTS.WASTELAND):
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
		add_child(node)
		node.set_name("Room" + str(i))
		node.set_loc(Vector2(i % area_w, int(i / area_h)))
		node.set_room_type(CONSTANTS.WASTELAND)

func place_saloons(room):
	for saloons in range(SALOONS):
		var room_pos = pick_room()
		var linear_room_pos = room_pos.x + room_pos.y * area_w
		get_node("Room" + str(linear_room_pos)).set_room_type(CONSTANTS.SALOON)

func place_inns(room):
	for inns in range(INNS):
		var room_pos = pick_room()
		var linear_room_pos = room_pos.x + room_pos.y * area_w
		get_node("Room" + str(linear_room_pos)).set_room_type(CONSTANTS.INN)

func add_walls_on_side(direction):
	if(branched_dir == -direction):
		return
	if(direction == Vector2(0, -1)):
		for pos in range(1, area_w - 1):
			get_node("Room" + str(pos)).set_room_type(CONSTANTS.WALL_N)
			if(direction == branching_dir or branched_dir == Vector2(0, 0)):
				get_node("Room" + str(pos)).set_room_type(CONSTANTS.WALL_DESTROY_N)
	if(direction == Vector2(0, 1)):
		for pos in range(area_w * (area_h - 1) + 1, area_w * area_h - 1):
			get_node("Room" + str(pos)).set_room_type(CONSTANTS.WALL_S)
			if(direction == branching_dir or branched_dir == Vector2(0, 0)):
				get_node("Room" + str(pos)).set_room_type(CONSTANTS.WALL_DESTROY_S)
	if(direction == Vector2(-1, 0)):
		for pos in range(area_w, area_w * (area_h - 1), area_w):
			get_node("Room" + str(pos)).set_room_type(CONSTANTS.WALL_W)
			if(direction == branching_dir or branched_dir == Vector2(0, 0)):
				get_node("Room" + str(pos)).set_room_type(CONSTANTS.WALL_DESTROY_W)
	if(direction == Vector2(1, 0)):
		for pos in range(area_w * 2 - 1, area_w * (area_h - 1), area_w):
			get_node("Room" + str(pos)).set_room_type(CONSTANTS.WALL_E)
			if(direction == branching_dir or branched_dir == Vector2(0, 0)):
				get_node("Room" + str(pos)).set_room_type(CONSTANTS.WALL_DESTROY_E)

func add_inside_corners():
	var wall_tex = load("res://Sprites/room_wall.png")
	get_node("Room" + str(0)).set_room_type(CONSTANTS.WALL_CORNER_NW)
	get_node("Room" + str(area_w - 1)).set_room_type(CONSTANTS.WALL_CORNER_NE)
	get_node("Room" + str(area_w * (area_h - 1))).set_room_type(CONSTANTS.WALL_CORNER_SW)
	get_node("Room" + str(area_w * area_h - 1)).set_room_type(CONSTANTS.WALL_CORNER_SE)

func add_corners():
	get_node("Room" + str(0)).set_room_type(CONSTANTS.WALL_NW)
	get_node("Room" + str(area_w - 1)).set_room_type(CONSTANTS.WALL_NE)
	get_node("Room" + str(area_w * (area_h - 1))).set_room_type(CONSTANTS.WALL_SW)
	get_node("Room" + str(area_w * area_h - 1)).set_room_type(CONSTANTS.WALL_SE)

func add_walls():
	add_corners()
	add_walls_on_side(Vector2(0, -1))
	add_walls_on_side(Vector2(0, 1))
	add_walls_on_side(Vector2(-1, 0))
	add_walls_on_side(Vector2(1, 0))

func translate_rooms(transform):
	for i in range(area_w * area_h):
		get_node("Room" + str(i)).set_loc( \
		get_node("Room" + str(i)).get_loc() + transform)

func _ready():
	CONSTANTS = get_node("/root/WorldConstants")
	
	randomize()
	
	var room = load("res://Scenes/Room.tscn")
	
	fill_wastelands(room)
	place_saloons(room)
	place_inns(room)