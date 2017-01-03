extends Node

var area_count = 0
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
		if(get_node("Area" + str(i)).get_loc() == loc):
			return true
	return false

func one_neighbor(loc, count):
	var neighbors = 0
	for i in range(count):
		if(get_node("Area" + str(i)).get_loc() == loc + Vector2(0, -1)):
			neighbors += 1
		elif(get_node("Area" + str(i)).get_loc() == loc + Vector2(0, 1)):
			neighbors += 1
		elif(get_node("Area" + str(i)).get_loc() == loc + Vector2(-1, 0)):
			neighbors += 1
		elif(get_node("Area" + str(i)).get_loc() == loc + Vector2(1, 0)):
			neighbors += 1
	return neighbors <= 2

func generate_world():
	var area = load("res://Scenes/Area.tscn")
	
	var center = Vector2(0, 0)
	
	var homeNode = area.instance()
	add_child(homeNode)
	homeNode.set_loc(center)
	homeNode.set_name("Area0")
	homeNode.set_branched(true)
	
	var leftNode = area.instance()
	add_child(leftNode)
	leftNode.set_loc(center + Vector2(-1, 0))
	leftNode.set_name("Area1")
	leftNode.branched_dir = Vector2(-1, 0)
	
	var rightNode = area.instance()
	add_child(rightNode)
	rightNode.set_loc(center + Vector2(1, 0))
	rightNode.set_name("Area2")
	rightNode.branched_dir = Vector2(1, 0)
	
	var upNode = area.instance()
	add_child(upNode)
	upNode.set_loc(center + Vector2(0, -1))
	upNode.set_name("Area3")
	upNode.branched_dir = Vector2(0, -1)
	
	var downNode = area.instance()
	add_child(downNode)
	downNode.set_loc(center + Vector2(0, 1))
	downNode.set_name("Area4")
	downNode.branched_dir = Vector2(0, 1)
	
	var count = 5
	var areas = 25
	var i = 0
	while i < areas - 5:
		var added_area = false
		for j in range(max(1, count - 4), count): # find an available branching point
			if(not get_node("Area" + str(j)).is_branched()):
				var loc = get_node("Area" + str(j)).get_loc()
				var new_node_loc
				var can_place = false
				var direction
				var timeout = 0
				while not can_place:
					direction = random_direction(get_node("Area" + str(j)).branched_dir)
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
				add_child(node)
				node.set_loc(new_node_loc)
				node.set_name("Area" + str(count))
				node.branched_dir = direction
				get_node("Area" + str(j)).set_branched(true)
				get_node("Area" + str(j)).branching_dir = direction
				added_area = true
				break
		if(added_area):
			count += 1
			i += 1
		else:
			i -= 1
	area_count = count

func clear_world():
	for i in range(area_count):
		var remove_node = get_node("Area" + str(i))
		remove_child(remove_node)
		remove_node.queue_free()

func update_areas():
	for i in range(area_count):
		get_node("Area" + str(i)).add_walls()

func translate_areas(transform):
	for i in range(area_count):
		get_node("Area" + str(i)).translate_rooms(transform)

func _ready():
	generate_world()
	update_areas()
	set_process_input(true)

func _input(event):
	if(event.is_action_pressed("ui_select")):
		clear_world()
		generate_world()
		update_areas()
	var transform = Vector2(0, 0)
	if(event.is_action_pressed("ui_up")):
		transform = Vector2(0, 1)
	if(event.is_action_pressed("ui_down")):
		transform = Vector2(0, -1)
	if(event.is_action_pressed("ui_left")):
		transform = Vector2(1, 0)
	if(event.is_action_pressed("ui_right")):
		transform = Vector2(-1, 0)
	translate_areas(transform)
	if(transform != Vector2(0, 0)):
		print(transform)