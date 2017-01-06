extends KinematicBody2D

signal on_kill

var health = 3

func get_center():
	return get_parent().get_parent().get_pos() + get_pos() + get_shape(0).get_extents()

func spawn_items():
	var drops = [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 4]
	var item_count = randi() % drops.size()
	for i in range(drops[item_count]):
		var inst = preload("res://Scenes/Item.tscn").instance()
		inst.set_pos(get_pos() + Vector2(16, 32))
		inst.set_spawn_delay(i * .1)
		var r = randi() % ItemConstants.ITEMS
		if(r == 0):
			inst.set_ID(ItemConstants.CRATE)
		elif(r == 1):
			inst.set_ID(ItemConstants.CRATE2)
		elif(r == 2):
			inst.set_ID(ItemConstants.CRATE3)
		elif(r == 3):
			inst.set_ID(ItemConstants.CRATE4)
		elif(r == 4):
			inst.set_ID(ItemConstants.CRATE5)
		elif(r == 5):
			inst.set_ID(ItemConstants.BIGCRATE)
		get_parent().get_parent().add_child(inst)

func kill():
	spawn_items()
	
	var k = preload("res://Scenes/EnemyKill.tscn").instance()
	k.set_texture(get_node("Sprite").get_texture())
	k.set_vframes(get_node("Sprite").get_vframes())
	k.set_hframes(get_node("Sprite").get_hframes())
	k.set_frame(get_node("Sprite").get_frame())
	k.set_pos(get_pos())
	get_parent().add_child(k)
	queue_free()
	get_parent().remove_child(self)

func hit():
	get_node("Sprite").flash()
	health -= 1
	if(health <= 0):
		emit_signal("on_kill", self)
		kill()