extends KinematicBody2D

var SPEED = 1000.0
var angle = 0
var out_of_bounds_time = 0
var velocity = Vector2(0, 0)
var bullet_hit
var damage = 1
var luck = 1.0

func set_damage(d):
	damage = d

func get_damage():
	return damage

func set_luck(l):
	luck = l

func get_luck():
	return luck

func set_direction(a):
	#get_node("Sprite").set_rot(a + PI / 2)
	a += PI
	angle = a
	velocity = Vector2(0, 1).rotated(angle)

func kill():
	var b = bullet_hit.instance()
	b.set_pos(get_pos())
	get_parent().add_child(b)
	queue_free()
	get_parent().remove_child(self)

func _ready():
	bullet_hit = preload("res://Scenes/BulletHit.tscn")
	
	set_fixed_process(true)

func _fixed_process(delta):
	move(velocity * delta * SPEED)
	if(is_colliding()):
		if(get_collider().is_in_group("enemies")):
			get_collider().hit(self)
		kill()
		return
	if(not get_parent().get_screen_area().overlaps_body(self)):
		out_of_bounds_time += 1
		if(out_of_bounds_time >= 5):
			kill()
			return
	else:
		out_of_bounds_time = 0