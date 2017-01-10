extends Sprite

func kill():
	queue_free()
	get_parent().remove_child(self)

func _ready():
	get_node("Animation").connect("animation_finished", self, "_on_animation_finished")
	
	get_node("Animation").add_animation("pop", range(1, 5), 15, false)
	get_node("Animation").play("pop")

func _on_animation_finished(anim):
	kill()