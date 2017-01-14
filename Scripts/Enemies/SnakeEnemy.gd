extends KinematicBody2D

signal on_kill

var damage = 1
var dead = false
var drop_luck = 1.0
var drop_money = 10.0 # average drop cash

func get_center():
	return get_parent().get_parent().get_pos() + get_pos() + get_shape(0).get_extents()

func spawn_items():
	var drops = [0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 4]
	var item_count = round(drop_luck * drops[randi() % drops.size()])
	for i in range(item_count):
		var inst = preload("res://Scenes/Item.tscn").instance()
		inst.set_pos(get_pos() + Vector2(16, 32))
		inst.set_spawn_delay(i * 0.05)
		
		var drop_table = [0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 3]
		var r = drop_table[randi() % drop_table.size()]
		inst.set_ID(r)
		#inst.gun_stats = preload("res://Scenes/Guns/WeaponStats.tscn").instance()
		#inst.gun_stats.set_stats(rand_range(1, 11), 1, rand_range(0.1, 1.0), 4, rand_range(5, 25), rand_range(100, 200), false, false, false, false, false, false, 1)
		if(r == ItemConstants.AMMO):
			inst.set_amount(1000)
		if(r == ItemConstants.MONEY):
			inst.set_amount(floor(drop_money * rand_range(0.75, 1.25)))
		if(r == ItemConstants.WHISKY):
			inst.set_amount(floor(rand_range(1, 5)))
		if(r == ItemConstants.WATERMELON):
			inst.set_amount(floor(rand_range(1, 2)))
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

func hit(bullet):
	get_node("EnemyControl").hostile = true
	get_node("Sprite").flash()
	get_node("Health").hurt(bullet.get_damage())
	drop_luck = bullet.get_luck()

func _ready():
	get_node("Health").set_full_hp(5)
	get_node("Health").set_hp(5)

func _on_killed():
	dead = true
	emit_signal("on_kill", self)
	kill()