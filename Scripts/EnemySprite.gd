extends Sprite

func flash():
	set_modulate(Color(255, 255, 255))
	get_node("FlashTimer").start()

func _ready():
	get_node("Animation").add_animation("walk n", range(32, 40), 15, true)
	get_node("Animation").add_animation("walk w", range(64, 72), 15, true)
	get_node("Animation").add_animation("walk s", range(0, 8), 15, true)
	get_node("Animation").add_animation("walk e", range(64, 72), 15, true, true)
	get_node("Animation").play("walk s")
	
	get_node("Shadow").set_color(Color(19 / 255.0, 0, 39 / 255.0, 0.5))

func _on_flash_timer_timeout():
	set_modulate(Color(1, 1, 1))