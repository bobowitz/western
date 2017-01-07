extends Sprite

func flash():
	set_modulate(Color(255, 255, 255))
	get_node("FlashTimer").start()

func _ready():
	get_node("Animation").add_animation("jump", range(192, 200), 15, false)
	get_node("Animation").play("jump")
	
	get_node("Shadow").set_color(Color(19 / 255.0, 0, 39 / 255.0, 0.5))

func _on_flash_timer_timeout():
	set_modulate(Color(1, 1, 1))