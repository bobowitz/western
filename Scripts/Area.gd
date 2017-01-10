extends Node

var INNS = 1
var SALOONS = 3

var town_name = ""
var loc = Vector2(0, 0) # location on grid, in units of areas
						# position of actual area object is always 0, 0
var room_transform = Vector2(0, 0)
var branched = false
var branched_dir = Vector2(0, 0)
var branching_dir = Vector2(0, 0)

func add_area_hitboxes():
	for i in range(WorldConstants.AREA_W * WorldConstants.AREA_H):
		get_node("Room" + str(i)).add_room_hitboxes()

func remove_area_hitboxes():
	for i in range(WorldConstants.AREA_W * WorldConstants.AREA_H):
		get_node("Room" + str(i)).remove_room_hitboxes()

func check_out_of_area(transform):
	var out_of_bounds = true
	for i in range(WorldConstants.AREA_W * WorldConstants.AREA_H):
		if(get_node("Room" + str(i)).get_loc() + transform == get_node("/root/Game/Camera").get_room_pos()):
			out_of_bounds = false
	return out_of_bounds

func get_current_room():
	for i in range(WorldConstants.AREA_W * WorldConstants.AREA_H):
		if(get_node("Room" + str(i)).get_loc() == get_node("/root/Game/Camera").get_room_pos()):
			return get_node("Room" + str(i))
	return null

func set_loc(l):
	loc = l

func get_loc():
	return loc

func is_branched():
	return branched

func set_branched(b):
	branched = b

func pick_room():
	var radius = 1
	
	var room_pos
	while true:
		room_pos = Vector2(randi() % (WorldConstants.AREA_W-2)+1, randi() % (WorldConstants.AREA_H-2)+1)
		
		var nearby_room = false
		for yy in range(room_pos.y - radius, room_pos.y + radius + 1):
			for xx in range(room_pos.x - radius, room_pos.x + radius + 1):
				if(xx < 0 or yy < 0 or xx >= WorldConstants.AREA_W or yy >= WorldConstants.AREA_H):
					continue
				var lin_pos = xx + yy * WorldConstants.AREA_W
				if(get_node("Room" + str(lin_pos)).get_room_type() != WorldConstants.WASTELAND):
					nearby_room = true
					break
			if(nearby_room):
				break
		if(not nearby_room):
			break
	return room_pos

func fill_wastelands(room):
	for i in range(WorldConstants.AREA_W * WorldConstants.AREA_H):
		var node = room.instance()
		add_child(node)
		node.set_name("Room" + str(i))
		node.set_loc(Vector2(i % WorldConstants.AREA_W, int(i / WorldConstants.AREA_H)))
		node.set_room_type(WorldConstants.WASTELAND)

func place_saloons(room):
	for saloons in range(SALOONS):
		var room_pos = pick_room()
		var linear_room_pos = room_pos.x + room_pos.y * WorldConstants.AREA_W
		get_node("Room" + str(linear_room_pos)).set_room_type(WorldConstants.SALOON)

func place_inns(room):
	for inns in range(INNS):
		var room_pos = pick_room()
		var linear_room_pos = room_pos.x + room_pos.y * WorldConstants.AREA_W
		get_node("Room" + str(linear_room_pos)).set_room_type(WorldConstants.INN)

func finish_rooms():
	for i in range(WorldConstants.AREA_W * WorldConstants.AREA_H):
		get_node("Room" + str(i)).finish_room()

func add_walls_on_side(direction):
	if(branched_dir == -direction):
		return
	if(direction == Vector2(0, -1)):
		for pos in range(1, WorldConstants.AREA_W - 1):
			get_node("Room" + str(pos)).set_room_type(WorldConstants.WALL_N)
			if(direction == branching_dir or branched_dir == Vector2(0, 0)):
				get_node("Room" + str(pos)).set_room_type(WorldConstants.WALL_DESTROY_N)
	if(direction == Vector2(0, 1)):
		for pos in range(WorldConstants.AREA_W * (WorldConstants.AREA_H - 1) + 1, WorldConstants.AREA_W * WorldConstants.AREA_H - 1):
			get_node("Room" + str(pos)).set_room_type(WorldConstants.WALL_S)
			if(direction == branching_dir or branched_dir == Vector2(0, 0)):
				get_node("Room" + str(pos)).set_room_type(WorldConstants.WALL_DESTROY_S)
	if(direction == Vector2(-1, 0)):
		for pos in range(WorldConstants.AREA_W, WorldConstants.AREA_W * (WorldConstants.AREA_H - 1), WorldConstants.AREA_W):
			get_node("Room" + str(pos)).set_room_type(WorldConstants.WALL_W)
			if(direction == branching_dir or branched_dir == Vector2(0, 0)):
				get_node("Room" + str(pos)).set_room_type(WorldConstants.WALL_DESTROY_W)
	if(direction == Vector2(1, 0)):
		for pos in range(WorldConstants.AREA_W * 2 - 1, WorldConstants.AREA_W * (WorldConstants.AREA_H - 1), WorldConstants.AREA_W):
			get_node("Room" + str(pos)).set_room_type(WorldConstants.WALL_E)
			if(direction == branching_dir or branched_dir == Vector2(0, 0)):
				get_node("Room" + str(pos)).set_room_type(WorldConstants.WALL_DESTROY_E)

func add_inside_corners():
	var wall_tex = load("res://Sprites/room_wall.png")
	get_node("Room" + str(0)).set_room_type(WorldConstants.WALL_CORNER_NW)
	get_node("Room" + str(WorldConstants.AREA_W - 1)).set_room_type(WorldConstants.WALL_CORNER_NE)
	get_node("Room" + str(WorldConstants.AREA_W * (WorldConstants.AREA_H - 1))).set_room_type(WorldConstants.WALL_CORNER_SW)
	get_node("Room" + str(WorldConstants.AREA_W * WorldConstants.AREA_H - 1)).set_room_type(WorldConstants.WALL_CORNER_SE)

func add_corners():
	get_node("Room" + str(0)).set_room_type(WorldConstants.WALL_NW)
	get_node("Room" + str(WorldConstants.AREA_W - 1)).set_room_type(WorldConstants.WALL_NE)
	get_node("Room" + str(WorldConstants.AREA_W * (WorldConstants.AREA_H - 1))).set_room_type(WorldConstants.WALL_SW)
	get_node("Room" + str(WorldConstants.AREA_W * WorldConstants.AREA_H - 1)).set_room_type(WorldConstants.WALL_SE)

func add_walls():
	add_corners()
	if(branching_dir != Vector2(0, 0)):
		add_walls_on_side(Vector2(0, -1))
		add_walls_on_side(Vector2(0, 1))
		add_walls_on_side(Vector2(-1, 0))
		add_walls_on_side(Vector2(1, 0))
	
	finish_rooms()

func _init():
	randomize()
	
	var room = preload("res://Scenes/Room.tscn")
	
	fill_wastelands(room)
	place_saloons(room)
	place_inns(room)