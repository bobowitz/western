extends Node

var area_w = 8
var area_h = 8
var branched = false
var branched_dir

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
		room_pos = Vector2(randi() % area_w, randi() % area_h)
		var nearby_room = false
		for yy in range(room_pos.y - radius, room_pos.y + radius + 1):
			for xx in range(room_pos.x - radius, room_pos.x + radius + 1):
				if(xx < 0 or yy < 0 or xx >= area_w or yy >= area_h):
					continue
				var lin_pos = xx + yy * area_w
				if(get_node("Room" + str(lin_pos)).get_room_type() != 0):
					nearby_room = true
					break
			if(nearby_room):
				break
		if(not nearby_room):
			break
	return room_pos

func _ready():
	randomize()
	
	var room = load("res://Scenes/Room.tscn")
	var alt_tex = load("res://Sprites/room.png")
	var alt_tex_2 = load("res://Sprites/room2.png")
	for i in range(area_w * area_h):
		var node = room.instance()
		node.set_name("Room" + str(i))
		node.get_node("Sprite").set_pos(Vector2((i % area_w) * 4, int(i / area_h) * 4))
		node.set_room_type(0)
		add_child(node)
	for saloons in range(3):
		var room_pos = pick_room()
		var linear_room_pos = room_pos.x + room_pos.y * area_w
		get_node("Room" + str(linear_room_pos)).get_node("Sprite").set_texture(alt_tex)
		get_node("Room" + str(linear_room_pos)).set_room_type(1)
	for stores in range(3):
		var room_pos = pick_room()
		var linear_room_pos = room_pos.x + room_pos.y * area_w
		get_node("Room" + str(linear_room_pos)).get_node("Sprite").set_texture(alt_tex_2)
		get_node("Room" + str(linear_room_pos)).set_room_type(2)