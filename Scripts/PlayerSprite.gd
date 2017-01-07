extends Sprite

var FLICKER_SPEED = 5 # milliseconds

func _ready():
	get_node("Animation").add_animation("idle", range(96, 104), 10, true)
	get_node("Animation").add_animation("walk n", range(32, 40), 15, true)
	get_node("Animation").add_animation("walk w", range(64, 72), 15, true)
	get_node("Animation").add_animation("walk s", range(0, 8), 15, true)
	get_node("Animation").add_animation("walk e", range(64, 72), 15, true, true)
	get_node("Animation").play("idle")
	
	set_process(true)

func _process(delta):
	if(get_node("../InvulnTimer").get_time_left() > 0):
		set_hidden(OS.get_ticks_msec() % (FLICKER_SPEED * 2) <= FLICKER_SPEED)