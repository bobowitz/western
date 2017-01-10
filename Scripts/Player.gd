extends KinematicBody2D

func _on_inventory_equipped_item(item): # only for guns rn
	if(has_node("Weapon")):
		get_node("Weapon").queue_free()
		remove_child(get_node("Weapon"))
	if(item == null):
		return
	else:
		if(item.ID == ItemConstants.REVOLVER_TINY):
			var gun = preload("res://Scenes/Guns/Revolver.tscn").instance()
			var gun_stats = preload("res://Scenes/Guns/WeaponStats.tscn").instance()
			gun_stats.copy_stats(item.gun_stats)
			gun.add_child(gun_stats)
			add_child(gun)
		if(item.ID == ItemConstants.REVOLVER_SMALL):
			var gun = preload("res://Scenes/Guns/Revolver.tscn").instance()
			var gun_stats = preload("res://Scenes/Guns/WeaponStats.tscn").instance()
			gun_stats.copy_stats(item.gun_stats)
			gun.add_child(gun_stats)
			add_child(gun)
		if(item.ID == ItemConstants.REVOLVER_MEDIUM):
			var gun = preload("res://Scenes/Guns/Revolver.tscn").instance()
			var gun_stats = preload("res://Scenes/Guns/WeaponStats.tscn").instance()
			gun_stats.copy_stats(item.gun_stats)
			gun.add_child(gun_stats)
			add_child(gun)
		if(item.ID == ItemConstants.REVOLVER_LARGE):
			var gun = preload("res://Scenes/Guns/Revolver.tscn").instance()
			var gun_stats = preload("res://Scenes/Guns/WeaponStats.tscn").instance()
			gun_stats.copy_stats(item.gun_stats)
			gun.add_child(gun_stats)
			add_child(gun)
		if(item.ID == ItemConstants.REVOLVER_HUGE):
			var gun = preload("res://Scenes/Guns/Revolver.tscn").instance()
			var gun_stats = preload("res://Scenes/Guns/WeaponStats.tscn").instance()
			gun_stats.copy_stats(item.gun_stats)
			gun.add_child(gun_stats)
			add_child(gun)
		if(item.ID == ItemConstants.BANANA):
			var gun = preload("res://Scenes/Guns/Revolver.tscn").instance()
			var gun_stats = preload("res://Scenes/Guns/WeaponStats.tscn").instance()
			gun_stats.copy_stats(item.gun_stats)
			gun.add_child(gun_stats)
			add_child(gun)