extends Node

var areas = []
var old_area_index = 0 # for transitions
var current_area_index = 0
var area_count = 15
var current_room

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

func _input(event):
	if(event.is_action_pressed("ui_select")):
		clear_world()
		generate_world()
		finish_areas()
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
	if(body == player):
		print("player exited")
		var out_dir = Vector2(0, 0)
		if(get_node("OutOfBoundsUp").overlaps_body(player) \
		and player.get_node("PlayerControl").direction.y == -1):
			out_dir.y = -1
		if(get_node("OutOfBoundsDown").overlaps_body(player) \
		and player.get_node("PlayerControl").direction.y == 1):
			out_dir.y = 1
		if(get_node("OutOfBoundsLeft").overlaps_body(player) \
		and player.get_node("PlayerControl").direction.x == -1):
			out_dir.x = -1
		if(get_node("OutOfBoundsRight").overlaps_body(player) \
		and player.get_node("PlayerControl").direction.x == 1):
			out_dir.x = 1
		print(get_node("OutOfBoundsUp").overlaps_body(player))
		print(get_node("OutOfBoundsDown").overlaps_body(player))
		print(get_node("OutOfBoundsLeft").overlaps_body(player))
		print(get_node("OutOfBoundsRight").overlaps_body(player))
		print(player.get_pos())
		var out_of_area = areas[current_area_index].check_out_of_area(-out_dir)
		if(not out_of_area):
			player.get_node("PlayerControl").translate_tween( \
					-out_dir * WorldConstants.room_size, \
					WorldConstants.ROOM_CHANGE_TWEEN_SPEED)
			var out_of_area = areas[current_area_index].translate_rooms_tween( \
					-out_dir, WorldConstants.ROOM_CHANGE_TWEEN_SPEED)
		else:
			for i in range(area_count): # find correct area
				if(areas[current_area_index].get_loc() + out_dir == areas[i].get_loc()):
					old_area_index = current_area_index
					areas[i].translate_rooms(areas[current_area_index].room_transform - out_dir + out_dir * \
						Vector2(WorldConstants.AREA_W, WorldConstants.AREA_H))
					delay_out_dir = out_dir
					current_area_index = i
					
					get_node("Transition").start()
					get_node("../Player/PlayerControl").freeze()
					break

func _on_transition_dark():
	remove_child(areas[old_area_index])
	areas[old_area_index].reset_room_transforms() # so when we reload it'll be where we expect it
	add_child(areas[current_area_index])
	get_node("/root/Game/Player").translate(-delay_out_dir * WorldConstants.room_size)

func _on_transition_fade_in():
	print("unfreeze")
	get_node("../Player/PlayerControl").unfreeze()