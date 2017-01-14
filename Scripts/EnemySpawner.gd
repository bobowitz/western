extends Node

var MAX_ENEMIES = 8
var MIN_ENEMIES = 0

func place_enemies():
	var r = randi() % (MAX_ENEMIES + 1 - MIN_ENEMIES) + MIN_ENEMIES
	for i in range(r):
		var type = randi() % 2
		var e
		if(type == 0):
			e = preload("res://Scenes/Enemies/SkullEnemy.tscn").instance()
		elif(type == 1):
			e = preload("res://Scenes/Enemies/SnakeEnemy.tscn").instance()
		var position = Vector2(0, 0)
		while(!WorldConstants.ENEMY_AREA.has_point(position)):
			position = Vector2(floor(rand_range(WorldConstants.ENEMY_AREA.pos.x, WorldConstants.ENEMY_AREA.pos.x + WorldConstants.ENEMY_AREA.size.x)), \
							   floor(rand_range(WorldConstants.ENEMY_AREA.pos.y, WorldConstants.ENEMY_AREA.pos.y + WorldConstants.ENEMY_AREA.size.y)))
		e.set_pos(position)
		e.add_to_group("enemies")
		add_child(e)
		e.connect("on_kill", self, "_on_child_killed")

func remove_enemies():
	for e in get_children():
		if(e.is_in_group("enemies")):
			e.queue_free()
			remove_child(e)

func remove_enemies_defer():
	for e in get_children():
		if(e.is_in_group("enemies")):
			e.call_deferred("queue_free")
			call_deferred("remove_child", "e")

func _on_room_enter():
	place_enemies()

func _on_room_leave():
	remove_enemies()

func _on_room_leave_defer():
	remove_enemies_defer()

func _on_child_killed(enemy):
	pass
	# do something with respawn times