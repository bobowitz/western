extends StaticBody2D

var GRAVITY = 2000.0
var FLICKER_TIME = 2.0 # seconds
var FLICKER_SPEED = 10 # milliseconds
var ID = 0
var kill_anim
var velocity = Vector2(0, 0)
var start_velocity_y = 0
var ground_y = 0
var spawned = false
var is_pickup = false # pickups don't go into inventory
var equippable = false
var is_gun = false
var gun_stats
var amount = 0 # for money and ammo

func set_amount(a):
	amount = a

func get_amount():
	return amount

func set_ID(id):
	ID = id
	get_node("Sprite").set_frame(ID)
	
	clear_shapes()
	var shape = RectangleShape2D.new()
	if(ID == ItemConstants.AMMO):
		shape.set_extents(Vector2(9, 9))
		is_pickup = true
	if(ID == ItemConstants.MONEY):
		shape.set_extents(Vector2(9, 9))
		is_pickup = true
	elif(ID == ItemConstants.WHISKY):
		shape.set_extents(Vector2(9, 9))
		is_pickup = true
	if(ID == ItemConstants.WATERMELON):
		shape.set_extents(Vector2(9, 9))
		is_pickup = true
	elif(ID == ItemConstants.REVOLVER_TINY):
		shape.set_extents(Vector2(9, 9))
		equippable = true
		is_gun = true
	elif(ID == ItemConstants.REVOLVER_SMALL):
		shape.set_extents(Vector2(9, 9))
		equippable = true
		is_gun = true
	elif(ID == ItemConstants.REVOLVER_MEDIUM):
		shape.set_extents(Vector2(9, 9))
		equippable = true
		is_gun = true
	elif(ID == ItemConstants.REVOLVER_LARGE):
		shape.set_extents(Vector2(9, 9))
		equippable = true
		is_gun = true
	elif(ID == ItemConstants.REVOLVER_HUGE):
		shape.set_extents(Vector2(9, 9))
		equippable = true
		is_gun = true
	elif(ID == ItemConstants.BANANA):
		shape.set_extents(Vector2(9, 9))
		equippable = true
		is_gun = true
	add_shape(shape)
	
	if(is_gun):
		get_node("Sprite").set_texture(preload("res://Sprites/guniconset.png"))
		get_node("Sprite").set_frame(ID - ItemConstants.FIRST_GUN)

func get_ID():
	return ID

func effect(target): # for pickups
	if(ID == ItemConstants.WHISKY):
		target.get_node("Health").hurt(-amount)
		var t = preload("res://Scenes/TextParticle.tscn").instance()
		t.set_text("+" + str(amount) + " health")
		t.set_color(WorldConstants.HEALTH_GREEN)
		t.set_pos(get_pos() + get_shape(0).get_extents())
		get_parent().add_child(t)
	elif(ID == ItemConstants.WATERMELON):
		target.get_node("Health").hurt(-amount)
		var t = preload("res://Scenes/TextParticle.tscn").instance()
		t.set_text("+" + str(amount) + " health")
		t.set_color(WorldConstants.HEALTH_GREEN)
		t.set_pos(get_pos() + get_shape(0).get_extents())
		get_parent().add_child(t)
	elif(ID == ItemConstants.AMMO):
		target.get_node("HUD/Inventory").add_ammo(amount)
		var t = preload("res://Scenes/TextParticle.tscn").instance()
		t.set_text("+" + str(amount) + " ammo")
		t.set_color(WorldConstants.HIGHLIGHT_COLOR)
		t.set_pos(get_pos() + get_shape(0).get_extents())
		get_parent().add_child(t)
	elif(ID == ItemConstants.MONEY):
		target.get_node("HUD/Inventory").add_money(amount)
		var t = preload("res://Scenes/TextParticle.tscn").instance()
		t.set_text("+" + str(amount) + " dollars")
		t.set_color(WorldConstants.HIGHLIGHT_COLOR)
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
	get_node("SpawnDelayTimer").start()

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