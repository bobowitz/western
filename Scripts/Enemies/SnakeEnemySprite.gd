extends Sprite

func flash():
	set_modulate(Color(255, 255, 255))
	get_node("FlashTimer").start()

func _ready():
	get_node("Animation").add_animation("snek", range(256, 264), 15, true)
	get_node("Animation").play("snek")
	
	get_node("Animation").disable_flipping()
	
	get_node("Shadow").set_color(Color(19 / 255.0, 0, 39 / 255.0, 0.5))

func _on_flash_timer_timeout():
	set_modulate(Color(1, 1, 1))