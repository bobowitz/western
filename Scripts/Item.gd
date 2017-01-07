extends StaticBody2D

var GRAVITY = 2000.0
var FLICKER_TIME = 2.0 # seconds
var FLICKER_SPEED = 10 # milliseconds
var ID = ItemConstants.CRATE
var kill_anim
var velocity = Vector2(0, 0)
var start_velocity_y = 0
var ground_y = 0
var spawned = false
var is_pickup = false # pickups don't go into inventory

func set_ID(id):
	ID = id
	get_node("Sprite").set_frame(ID)
	
	clear_shapes()
	var shape = RectangleShape2D.new()
	if(ID == ItemConstants.CRATE):
		shape.set_extents(Vector2(9, 9))
	elif(ID == ItemConstants.CRATE2):
		shape.set_extents(Vector2(9, 9))
	elif(ID == ItemConstants.CRATE3):
		shape.set_extents(Vector2(9, 9))
	elif(ID == ItemConstants.CRATE4):
		shape.set_extents(Vector2(9, 9))
	elif(ID == ItemConstants.CRATE5):
		shape.set_extents(Vector2(9, 9))
	elif(ID == ItemConstants.BIGCRATE):
		shape.set_extents(Vector2(16, 16))
	elif(ID == ItemConstants.FLASK):
		shape.set_extents(Vector2(9, 9))
		is_pickup = true
	add_shape(shape)

func get_ID():
	return ID

func effect(target): # for pickups
	target.get_node("Health").hurt(-1)
	var t = preload("res://Scenes/TextParticle.tscn").instance()
	t.set_text("+1 health")
	t.set_color(WorldConstants.HEALTH_GREEN)
	t.set_pos(get_pos() + get_shape(0).get_extents())
	get_parent().add_child(t)

func despawn(): # if not picked up
	queue_free()
	get_parent().remove_child(self)

func kill(): # if picked up
	var k = kill_anim.instance()
	k.set_texture(get_node("Sprite").get_texture())
	k.set_vframes(get_node("Sprite").get_vframes())
	k.set_hframes(get_node("Sprite").get_hframes())
	k.set_frame(get_node("Sprite").get_frame())
	k.set_pos(get_pos())
	get_parent().add_child(k)
	despawn()

func set_spawn_delay(delay):
	if(delay < 0.01):
		delay = 0.01
	get_node("SpawnDelayTimer").set_wait_time(delay)

func spawn():
	get_node("DespawnTimer").start()
	
	spawned = true
	
	ground_y = get_pos().y + rand_range(-10, 10)
	velocity = Vector2(rand_range(-100, 100), rand_range(-200, -300))
	start_velocity_y = velocity.y
	
	get_node("Sprite").set_hidden(false)

func _ready():
	kill_anim = preload("res://Scenes/ItemKill.tscn")
	
	get_node("Sprite").set_hidden(true)
	set_scale(Vector2(0, 0))
	
	set_fixed_process(true)
	set_process(true)

func _process(delta):
	if(not spawned):
		return
	
	if(get_node("DespawnTimer").get_time_left() < FLICKER_TIME):
		get_node("Sprite").set_hidden(OS.get_ticks_msec() % (FLICKER_SPEED * 2) <= FLICKER_SPEED)

func _fixed_process(delta):
	if(not spawned):
		return
	
	translate(velocity * delta)
	
	if(velocity.y < 0):
		var scale = (start_velocity_y - velocity.y) / start_velocity_y
		set_scale(Vector2(scale, scale))
	else:
		set_scale(Vector2(1, 1))
	
	if(get_pos().y >= ground_y and velocity.y > 0):
		set_pos(Vector2(get_pos().x, ground_y))
		velocity = Vector2(0, 0)
	
	velocity.y += GRAVITY * delta

func _on_timer_timeout():
	despawn()

func _on_spawn_delay_timer_timeout():
	spawn()