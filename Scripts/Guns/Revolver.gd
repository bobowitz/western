extends Sprite

func shoot():
	var b = preload("res://Scenes/Bullet.tscn").instance()
	b.set_pos(get_parent().get_pos() + get_pos() + Vector2(0, get_node("WeaponControl").x_offset).rotated(get_node("WeaponControl").angle + PI))
	b.set_damage(get_node("WeaponStats")._damage)
	b.set_luck(get_node("WeaponStats")._luck)
	b.set_direction(get_node("WeaponControl").angle)
	b.add_to_group("bullets")
	get_node("/root/Game/World").add_child(b)
	
	# knockback
	get_parent().move(-Vector2(0, get_node("WeaponStats")._knockback).rotated(get_node("WeaponControl").angle + PI))
	
	# recoil
	get_node("WeaponControl").recoil = 1
	
	# camera shake
	get_node("/root/Game/Camera").shake(Vector2(0, 5).rotated(get_node("WeaponControl").angle + PI))