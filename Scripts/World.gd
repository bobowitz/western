extends Node

# 17 x 17 grid

func random_direction(bias):
	var r = randi() % 4
	var direction
	while true:
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
		else:
			if(randf() < 0.25):
				break
	return direction

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
		elif(get_node("Area" + str(i)).get_loc() == loc):
			neighbors += 1
	return neighbors == 1

func generate_world():
	var area = load("res://Scenes/Area.tscn")
	
	var homeNode = area.instance()
	homeNode.set_loc(Vector2(8, 8))
	homeNode.set_name("Area0")
	homeNode.set_branched(true)
	add_child(homeNode)
	
	var leftNode = area.instance()
	leftNode.set_loc(Vector2(7, 8))
	leftNode.set_name("Area1")
	leftNode.branched_dir = Vector2(-1, 0)
	add_child(leftNode)
	
	var rightNode = area.instance()
	rightNode.set_loc(Vector2(9, 8))
	rightNode.set_name("Area2")
	rightNode.branched_dir = Vector2(1, 0)
	add_child(rightNode)
	
	var upNode = area.instance()
	upNode.set_loc(Vector2(8, 7))
	upNode.set_name("Area3")
	upNode.branched_dir = Vector2(0, -1)
	add_child(upNode)
	
	var downNode = area.instance()
	downNode.set_loc(Vector2(8, 9))
	downNode.set_name("Area4")
	downNode.branched_dir = Vector2(0, 1)
	add_child(downNode)
	
	var count = 5
	var areas = 20
	for i in range(areas - 5):
		for j in range(count): # find an available branching point
			if(not get_node("Area" + str(j)).is_branched()):
				var loc = get_node("Area" + str(j)).get_loc()
				var new_node_loc
				var can_place = false
				var direction
				while not can_place:
					direction = random_direction(get_node("Area" + str(j)).branched_dir)
					if(one_neighbor(Vector2(loc.x, loc.y) + direction, count)):
						new_node_loc = loc + direction
						can_place = true
				var node = area.instance()
				node.set_loc(new_node_loc)
				node.set_name("Area" + str(count))
				node.branched_dir = direction
				get_node("Area" + str(j)).set_branched(true)
				add_child(node)
				break
		count += 1

func _ready():
	generate_world()