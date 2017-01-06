extends Sprite

var FLICKER_SPEED = 5 # milliseconds

func _ready():
	get_node("Animation").add_animation("idle", range(96, 104), 10, true)
	get_node("Animation").add_animation("walk n", range(32, 40), 15, true)
	get_node("Animation").add_animation("walk w", range(64, 72), 15, true)
	get_node("Animation").add_animation("walk s", range(0, 8), 15, true)
	get_node("Animation").add_animation("walk e", range(64, 72), 15, true, true)
	get_node("Animation").play("idle")
	
	get_node("Shadow").set_color(Color(19 / 255.0, 0, 39 / 255.0, 0.5))
	
	set_process(true)

func _process(delta):
	if(get_node("../InvulnTimer").get_time_left() > 0):
		set_hidden(OS.get_ticks_msec() % (FLICKER_SPEED * 2) <= FLICKER_SPEED)