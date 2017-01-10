extends Node

var room_type
var screen_hitbox
var up_hitbox
var down_hitbox
var left_hitbox
var right_hitbox
var item

func add_room_hitboxes():
	add_child(screen_hitbox.instance())
	add_child(up_hitbox.instance())
	add_child(down_hitbox.instance())
	add_child(left_hitbox.instance())
	add_child(right_hitbox.instance())

func remove_room_hitboxes():
	get_node("ScreenArea").queue_free()
	remove_child(get_node("ScreenArea"))
	get_node("OutOfBoundsUp").queue_free()
	remove_child(get_node("OutOfBoundsUp"))
	get_node("OutOfBoundsDown").queue_free()
	remove_child(get_node("OutOfBoundsDown"))
	get_node("OutOfBoundsLeft").queue_free()
	remove_child(get_node("OutOfBoundsLeft"))
	get_node("OutOfBoundsRight").queue_free()
	remove_child(get_node("OutOfBoundsRight"))

func set_loc(loc):
	set_pos(loc * WorldConstants.ROOM_SIZE)

func get_loc():
	return (get_pos() / WorldConstants.ROOM_SIZE).floor()

func get_room_type():
	return room_type

func set_room_type(r):
	room_type = r

func finish_room_type():
	var r = room_type
	if(r == WorldConstants.SALOON):
		get_node("Background").set_texture(RoomTextures.saloon_tex)
		add_child(preload("res://Scenes/Hitboxes/Saloon.tscn").instance())
		add_child(preload("res://Scenes/Hitboxes/SaloonBullet.tscn").instance())
		add_child(preload("res://Scenes/Hitboxes/SaloonDoor.tscn").instance())
	elif(r == WorldConstants.INN):
		get_node("Background").set_texture(RoomTextures.inn_tex)
	elif(r == WorldConstants.WALL_N):
		add_child(preload("res://Scenes/Hitboxes/WallN.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_n_tex)
	elif(r == WorldConstants.WALL_NW):
		add_child(preload("res://Scenes/Hitboxes/WallNW.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_nw_tex)
	elif(r == WorldConstants.WALL_W):
		add_child(preload("res://Scenes/Hitboxes/WallW.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_w_tex)
	elif(r == WorldConstants.WALL_SW):
		add_child(preload("res://Scenes/Hitboxes/WallSW.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_sw_tex)
	elif(r == WorldConstants.WALL_S):
		add_child(preload("res://Scenes/Hitboxes/WallS.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_s_tex)
	elif(r == WorldConstants.WALL_SE):
		add_child(preload("res://Scenes/Hitboxes/WallSE.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_sw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_E):
		add_child(preload("res://Scenes/Hitboxes/WallE.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_w_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_NE):
		add_child(preload("res://Scenes/Hitboxes/WallNE.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_nw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_CORNER_NW):
		get_node("Background").set_texture(RoomTextures.wall_corner_nw_tex)
	elif(r == WorldConstants.WALL_CORNER_SW):
		get_node("Background").set_texture(RoomTextures.wall_corner_sw_tex)
	elif(r == WorldConstants.WALL_CORNER_SE):
		get_node("Background").set_texture(RoomTextures.wall_corner_sw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_CORNER_NE):
		get_node("Background").set_texture(RoomTextures.wall_corner_nw_tex)
		get_node("Background").set_flip_h(true)
	elif(r == WorldConstants.WALL_DESTROY_N):
		add_child(preload("res://Scenes/Hitboxes/WallDestroyN.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_destroy_n_tex)
	elif(r == WorldConstants.WALL_DESTROY_W):
		add_child(preload("res://Scenes/Hitboxes/WallDestroyW.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_destroy_w_tex)
	elif(r == WorldConstants.WALL_DESTROY_S):
		add_child(preload("res://Scenes/Hitboxes/WallDestroyS.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_destroy_s_tex)
	elif(r == WorldConstants.WALL_DESTROY_E):
		add_child(preload("res://Scenes/Hitboxes/WallDestroyE.tscn").instance())
		get_node("Background").set_texture(RoomTextures.wall_destroy_w_tex)
		get_node("Background").set_flip_h(true)

func pick_object_position():
	var position = Vector2(0, 0)
	var too_close = true
	while(too_close):
		position = Vector2(floor(rand_range(32, WorldConstants.ROOM_SIZE.x - 32)), \
						   floor(rand_range(32, WorldConstants.ROOM_SIZE.y - 32)))
		too_close = false
		for child in get_children():
			if(child.is_in_group("env") and child.get_pos().distance_to(position) < 64):
				too_close = true
	return position

func add_objects():
	var cactus_count = randi() % 4
	for i in range(cactus_count):
		var cactus = preload("res://Scenes/Objects/Cactus.tscn").instance()
		cactus.set_pos(pick_object_position())
		add_child(cactus)
	var holes_count = randi() % 4
	for i in range(holes_count):
		var holes = preload("res://Scenes/Objects/GroundHoles.tscn").instance()
		holes.set_pos(pick_object_position())
		add_child(holes)
	var bush_count = randi() % 4
	for i in range(bush_count):
		var bush = preload("res://Scenes/Objects/Bush.tscn").instance()
		bush.set_pos(pick_object_position())
		add_child(bush)

func finish_room():
	finish_room_type()
	
	if(room_type == WorldConstants.WASTELAND):
		add_child(preload("res://Scenes/EnemySpawner.tscn").instance())
		add_objects()

func _ready():
	screen_hitbox = preload("res://Scenes/Hitboxes/ScreenArea.tscn")
	up_hitbox = preload("res://Scenes/Hitboxes/OutOfBoundsUp.tscn")
	down_hitbox = preload("res://Scenes/Hitboxes/OutOfBoundsDown.tscn")
	left_hitbox = preload("res://Scenes/Hitboxes/OutOfBoundsLeft.tscn")
	right_hitbox = preload("res://Scenes/Hitboxes/OutOfBoundsRight.tscn")

func _on_room_enter():
	if(has_node("EnemySpawner")):
		get_node("EnemySpawner")._on_room_enter()

func _on_room_leave_defer():
	if(has_node("EnemySpawner")):
		get_node("EnemySpawner")._on_room_leave_defer()

func _on_room_leave():
	if(has_node("EnemySpawner")):
		get_node("EnemySpawner")._on_room_leave()