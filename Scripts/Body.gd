extends Area2D

func get_center():
	return get_parent().get_pos() + get_shape(0).get_extents()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	for body in get_overlapping_bodies():
		if(body.is_in_group("enemies") and not body.dead):
			get_node("../PlayerControl").knockback((get_center() - body.get_center()).normalized())
			get_node("../Health").hurt(body.damage)
			get_node("../InvulnTimer").start()
			#invuln
			set_collision_mask_bit(4, false) # don't collide with enemies
			set_collision_mask_bit(5, false) # don't collide with enemy bullets
		if(body.is_in_group("items")):
			if(body.is_pickup):
				body.effect(get_parent())
			else:
				get_node("../HUD/Inventory").add_item(body) # yeah being in the HUD seems stupid but it works so
			body.kill()

func _on_invuln_timer_timeout():
	set_collision_mask_bit(4, true) # collide with enemies
	set_collision_mask_bit(5, true) # collide with enemy bullets
	get_node("../Sprite").set_hidden(false)

func _on_killed():
	get_node("../PlayerControl").freeze()
	get_parent().set_hidden(true)