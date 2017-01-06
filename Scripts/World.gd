extends Node2D

var areas = []
var old_area_index = 0 # for transitions
var current_area_index = 0
var area_count = 15
var current_room

func get_current_room():
	return areas[current_area_index].get_current_room()

func get_screen_area():
	var index = current_area_index
	if(old_area_index != current_area_index): # transitioning, use old area
		index = old_area_index
	return areas[index].get_current_room().get_node("ScreenArea")

func random_direction(bias):
	var direction
	while true:
		var r = randi() % 4
		if(r == 0):
			direction = Vector2(0, -1)
		elif(r == 1):
			direction = Vector2(0, 1)
		elif(r == 2):
			direction = Vector2(-1, 0)
		else: # r == 3
			direction = Vector2(1, 0)
		if(direction != bias):
			break
		elif(randf() < 0.25):
			break
	return direction

func has_area(loc, count):
	for i in range(count):
		if(areas[i].get_loc() == loc):
			return true
	return false

func one_neighbor(loc, count):
	var neighbors = 0
	for i in range(count):
		if(areas[i].get_loc() == loc + Vector2(0, -1)):
			neighbors += 1
		elif(areas[i].get_loc() == loc + Vector2(0, 1)):
			neighbors += 1
		elif(areas[i].get_loc() == loc + Vector2(-1, 0)):
			neighbors += 1
		elif(areas[i].get_loc() == loc + Vector2(1, 0)):
			neighbors += 1
	return neighbors <= 2

func generate_world():
	var area = preload("res://Scenes/Area.tscn")
	
	var center = Vector2(0, 0)
	
	var homeNode = area.instance()
	homeNode.set_loc(center)
	homeNode.set_name("Area0")
	homeNode.set_branched(true)
	areas.push_back(homeNode)
	
	var leftNode = area.instance()
	leftNode.set_loc(center + Vector2(-1, 0))
	leftNode.set_name("Area1")
	leftNode.branched_dir = Vector2(-1, 0)
	areas.push_back(leftNode)
	
	var rightNode = area.instance()
	rightNode.set_loc(center + Vector2(1, 0))
	rightNode.set_name("Area2")
	rightNode.branched_dir = Vector2(1, 0)
	areas.push_back(rightNode)
	
	var upNode = area.instance()
	upNode.set_loc(center + Vector2(0, -1))
	upNode.set_name("Area3")
	upNode.branched_dir = Vector2(0, -1)
	areas.push_back(upNode)
	
	var downNode = area.instance()
	downNode.set_loc(center + Vector2(0, 1))
	downNode.set_name("Area4")
	downNode.branched_dir = Vector2(0, 1)
	areas.push_back(downNode)
	
	var count = 5
	var i = 0
	while i < area_count - 5:
		var added_area = false
		for j in range(max(1, count - 4), count): # find an available branching point
			if(not areas[j].is_branched()):
				var loc = areas[j].get_loc()
				var new_node_loc
				var can_place = false
				var direction
				var timeout = 0
				while not can_place:
					direction = random_direction(areas[j].branched_dir)
					if(not has_area(Vector2(loc.x, loc.y) + direction, count) \
					and one_neighbor(Vector2(loc.x, loc.y) + direction, count)):
						new_node_loc = loc + direction
						can_place = true
					timeout += 1
					if(timeout > 100):
						timeout = -1
						break
				if(timeout == -1):
					break
				var node = area.instance()
				node.set_loc(new_node_loc)
				node.set_name("Area" + str(count))
				node.branched_dir = direction
				areas.push_back(node)
				
				areas[j].set_branched(true)
				areas[j].branching_dir = direction
				added_area = true
				
				break
		if(added_area):
			count += 1
			i += 1
		else:
			i -= 1
	if(count != area_count):
		print("FAILED TO GENERATE AREAS, COUNT != AREA_COUNT")

func clear_world():
	for i in range(area_count):
		areas[i].queue_free()

func finish_areas():
	for i in range(area_count):
		areas[i].add_walls()

func _ready():
	generate_world()
	finish_areas()
	set_process_input(true)
	add_child(areas[current_area_index])
	areas[current_area_index].add_area_hitboxes()
	areas[current_area_index].get_current_room().get_node("ScreenArea").connect("body_exit", self, "_on_area_body_exit")

func _input(event):
	var transform = Vector2(0, 0)
	if(event.is_action_pressed("ui_up")):
		transform = Vector2(0, 1)
	if(event.is_action_pressed("ui_down")):
		transform = Vector2(0, -1)
	if(event.is_action_pressed("ui_left")):
		transform = Vector2(1, 0)
	if(event.is_action_pressed("ui_right")):
		transform = Vector2(-1, 0)
	if(transform != Vector2(0, 0)):
		areas[current_area_index].translate_rooms_tween(transform, 0.25)

var delay_out_dir = Vector2(0, 0)
func _on_area_body_exit(body):
	var player = get_node("/root/Game/Player")
	var r = areas[current_area_index].get_current_room()
	if(body == player):
		var out_dir = Vector2(0, 0)
		if(r.get_node("OutOfBoundsUp").overlaps_body(player)):
			out_dir.y = -1
		if(r.get_node("OutOfBoundsDown").overlaps_body(player)):
			out_dir.y = 1
		if(r.get_node("OutOfBoundsLeft").overlaps_body(player)):
			out_dir.x = -1
		if(r.get_node("OutOfBoundsRight").overlaps_body(player)):
			out_dir.x = 1
		var out_of_area = areas[current_area_index].check_out_of_area(-out_dir)
		if(not out_of_area):
			player.translate(out_dir * Vector2(32, 32))
			r.get_node("ScreenArea").disconnect("body_exit", self, "_on_area_body_exit")
			r._on_room_leave_defer()
			get_node("../Player/PlayerControl").freeze()
			get_node("/root/Game/Camera").move_rooms_tween(out_dir)
			areas[current_area_index].get_current_room().get_node("ScreenArea").connect("body_exit", self, "_on_area_body_exit")
			areas[current_area_index].get_current_room()._on_room_enter()
		else:
			for i in range(area_count): # find correct area
				if(areas[current_area_index].get_loc() + out_dir == areas[i].get_loc()):
					areas[old_area_index].get_current_room().get_node("ScreenArea").disconnect("body_exit", self, "_on_area_body_exit")
					old_area_index = current_area_index
					current_area_index = i
					delay_out_dir = out_dir
					
					get_node("Transition").start()
					get_node("../Player/PlayerControl").freeze()
					break

func _on_transition_dark():
	areas[old_area_index].get_current_room()._on_room_leave()
	areas[old_area_index].remove_area_hitboxes()
	remove_child(areas[old_area_index])
	
	old_area_index = current_area_index
	
	get_node("/root/Game/Camera").move_rooms(-delay_out_dir * (WorldConstants.AREA_SIZE - Vector2(1, 1)))
	
	add_child(areas[current_area_index])
	areas[current_area_index].add_area_hitboxes()
	areas[current_area_index].get_current_room().get_node("ScreenArea").connect("body_exit", self, "_on_area_body_exit")
	areas[current_area_index].get_current_room()._on_room_enter()
	get_node("/root/Game/Player").translate(-delay_out_dir * (WorldConstants.ROOM_SIZE * WorldConstants.AREA_SIZE - Vector2(32, 32)))

func _on_transition_done():
	get_node("../Player/PlayerControl").unfreeze()

func _on_camera_tween_finished():
	get_node("../Player/PlayerControl").unfreeze()